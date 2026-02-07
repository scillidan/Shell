# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "tencentcloud-sdk-python",
#     "langid"
# ]
# ///

# Tencent Cloud Translation API wrapper for subtitle translation.
# Authors: MiniMax-M2.1🧙‍♂️, scillidan🤡
# Install:
# 1. Get your API-Key from https://cloud.tencent.com/product/tmt
# 2. In environment, add:
# TENCENT_SECRET_ID=<YOUR_SECRET_ID>
# TENCENT_SECRET_KEY=<YOUR_SECRET_KEY>
# Usage:
# uv run tencent_trans_sub.py --source en --target zh --input subtitles.srt [--output translated.srt]

import json
import sys
import os
import argparse
import textwrap
import unicodedata
import re
import time
import threading
import queue
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Optional, Tuple, List, Dict
import langid

from tencentcloud.common import credential
from tencentcloud.common.profile.client_profile import ClientProfile
from tencentcloud.common.profile.http_profile import HttpProfile
from tencentcloud.common.exception.tencent_cloud_sdk_exception import (
    TencentCloudSDKException,
)
from tencentcloud.tmt.v20180321 import tmt_client, models


class RateLimiter:
    def __init__(self, max_qps: int):
        self.max_qps = max_qps
        self.min_interval = 1.0 / max_qps if max_qps > 0 else 0
        self.lock = threading.Lock()
        self.last_request_time = time.monotonic()

    def acquire(self):
        if self.max_qps <= 0:
            return
        with self.lock:
            now = time.monotonic()
            elapsed = now - self.last_request_time
            if elapsed < self.min_interval:
                time.sleep(self.min_interval - elapsed)
            self.last_request_time = time.monotonic()


SECRET_ID = os.getenv("TENCENT_SECRET_ID")
SECRET_KEY = os.getenv("TENCENT_SECRET_KEY")
REGION = "ap-shanghai"
PROJECT_ID = 0

sys.stdout.reconfigure(encoding="utf-8")


def clean_surrogates(text: str) -> str:
    if not text:
        return ""

    cleaned = "".join(char for char in text if not ("\ud800" <= char <= "\udfff"))

    return cleaned


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent("""
            Tencent Cloud Translation for Subtitle Files
            Translates subtitle files between languages.
            Supports SRT format by default.
        """),
    )
    parser.add_argument(
        "--source",
        type=str,
        default="auto",
        help='Source language code (e.g., en, ja, ko). Use "auto" for auto-detection.',
    )
    parser.add_argument(
        "--target",
        type=str,
        required=True,
        help="Target language code (e.g., zh, en, ja)",
    )
    parser.add_argument(
        "--input",
        type=str,
        default=None,
        help="Input subtitle file path (default: <basename>.srt)",
    )
    parser.add_argument(
        "--output",
        type=str,
        default=None,
        help="Output subtitle file path (default: <basename>.<target>.srt)",
    )
    parser.add_argument(
        "--silent", action="store_true", help="Suppress progress messages"
    )
    parser.add_argument(
        "--workers",
        type=int,
        default=5,
        help="Number of parallel workers (default: 5)",
    )
    parser.add_argument(
        "--max-qps",
        type=int,
        default=5,
        help="Maximum queries per second (default: 5)",
    )
    return parser.parse_args()


def normalize_text(text: str) -> str:
    if not text:
        return ""

    text = clean_surrogates(text)

    try:
        normalized = unicodedata.normalize("NFKC", text)
    except:
        normalized = text

    problematic_chars = [
        "\x00",
        "\x01",
        "\x02",
        "\x03",
        "\x04",
        "\x05",
        "\x06",
        "\x07",
        "\x08",
        "\x0b",
        "\x0c",
        "\x0e",
        "\x0f",
        "\u200b",
        "\u200c",
        "\u200d",
        "\ufeff",
    ]
    for char in problematic_chars:
        normalized = normalized.replace(char, "")

    chinese_to_english = {
        "，": ",",
        "。": ".",
        "！": "!",
        "？": "?",
        "；": ";",
        "：": ":",
        """": '"',
        """: '"',
        "'": "'",
        "'": "'",
        "《": "<",
        "》": ">",
        "【": "[",
        "】": "]",
        "「": '"',
        "」": '"',
        "『": '"',
        "』": '"',
        "〔": "[",
        "〕": "]",
        "——": "--",
        "…": "...",
        "·": ".",
        "、": ",",
        "～": "~",
        "﹃": "[",
        "﹄": "]",
        "﹁": "[",
        "﹂": "]",
        "．": ".",
    }
    for cn, en in chinese_to_english.items():
        normalized = normalized.replace(cn, en)

    english_punct_to_space = ",!?:;\"'[]{}<>/\\|@#$%^&*_+=~"
    chars_to_keep = "-()"
    for char in english_punct_to_space:
        if char not in chars_to_keep:
            normalized = normalized.replace(char, " ")

    normalized = normalized.strip()

    return normalized


def safe_json_dumps(obj, ensure_ascii: bool = False) -> str:
    try:
        json_str = json.dumps(obj, ensure_ascii=ensure_ascii)
    except UnicodeEncodeError:
        json_str = json.dumps(obj, ensure_ascii=True)

    json_str = clean_surrogates(json_str)
    return json_str


def detect_language(text: str) -> Optional[str]:
    if not text or not text.strip():
        return None

    try:
        detected_lang, confidence = langid.classify(text)

        lang_map = {
            "zh": "zh",
            "en": "en",
            "ja": "ja",
            "ko": "ko",
            "fr": "fr",
            "de": "de",
            "es": "es",
            "it": "it",
            "ru": "ru",
            "pt": "pt",
            "ar": "ar",
            "th": "th",
            "vi": "vi",
            "ms": "ms",
        }

        return lang_map.get(detected_lang, "en")

    except Exception as e:
        if any("\u4e00" <= char <= "\u9fff" for char in text):
            return "zh"
        return "en"


def initialize_tencent_client() -> Optional[tmt_client.TmtClient]:
    if not SECRET_ID or not SECRET_KEY:
        raise ValueError(
            "API credentials not configured. Please set TENCENT_SECRET_ID and TENCENT_SECRET_KEY."
        )

    try:
        cred = credential.Credential(SECRET_ID, SECRET_KEY)

        http_profile = HttpProfile()
        http_profile.endpoint = "tmt.tencentcloudapi.com"
        http_profile.req_timeout = 30

        client_profile = ClientProfile()
        client_profile.httpProfile = http_profile
        client_profile.signMethod = "TC3-HMAC-SHA256"

        client = tmt_client.TmtClient(cred, REGION, client_profile)

        return client

    except TencentCloudSDKException as e:
        raise Exception(f"Failed to initialize Tencent Cloud client: {str(e)}")


def translate_text(
    text: str,
    source_lang: str,
    target_lang: str,
    silent: bool = False,
    rate_limiter: Optional[RateLimiter] = None,
) -> Optional[str]:
    if not text or not text.strip():
        return None

    normalized_text = normalize_text(text)
    if not normalized_text:
        return None

    retry_count = 0
    max_retries = 3

    while retry_count < max_retries:
        try:
            if rate_limiter:
                rate_limiter.acquire()

            client = initialize_tencent_client()

            req = models.TextTranslateRequest()
            params = {
                "SourceText": normalized_text,
                "Source": source_lang,
                "Target": target_lang,
                "ProjectId": PROJECT_ID,
            }

            json_str = safe_json_dumps(params, ensure_ascii=False)
            req.from_json_string(json_str)

            resp = client.TextTranslate(req)
            dict_resp = json.loads(resp.to_json_string())

            translated_text = dict_resp.get("TargetText")

            if translated_text:
                translated_text = clean_surrogates(translated_text)
                return translated_text
            else:
                if not silent:
                    print(f"Warning: No translation returned for text: {text[:50]}...")
                return None

        except TencentCloudSDKException as e:
            error_code = str(e)
            if "RequestLimitExceeded" in error_code:
                retry_count += 1
                wait_time = 1.0 * retry_count
                if not silent:
                    print(
                        f"Rate limited, waiting {wait_time:.1f}s and retrying ({retry_count}/{max_retries})..."
                    )
                time.sleep(wait_time)
                continue
            if not silent:
                print(f"Tencent Cloud API Error: {str(e)}")
            if "AuthFailure" in error_code:
                if not silent:
                    print(
                        "Authentication failed. Please check your SecretId and SecretKey."
                    )
            elif "FailedOperation.NoFreeAmount" in error_code:
                if not silent:
                    print("Free quota exhausted. Please upgrade to paid service.")

            return None

        except Exception as e:
            if not silent:
                print(f"Unexpected error: {str(e)}")
            return None

    return None


def parse_srt(content: str) -> List[Dict]:
    subtitles = []
    blocks = content.strip().split("\n\n")

    for block in blocks:
        lines = block.strip().split("\n")
        if len(lines) < 3:
            continue

        try:
            index = int(lines[0])

            if "-->" not in lines[1]:
                continue

            time_line = lines[1]
            times = time_line.split(" --> ")
            start_time = times[0].strip()
            end_time = times[1].strip()

            text_lines = lines[2:]
            text = " ".join(line.strip() for line in text_lines if line.strip())

            subtitles.append(
                {
                    "index": index,
                    "start_time": start_time,
                    "end_time": end_time,
                    "text": text,
                }
            )
        except (ValueError, IndexError):
            continue

    return subtitles


def build_srt(subtitles: List[Dict]) -> str:
    lines = []
    for sub in subtitles:
        lines.append(str(sub["index"]))
        lines.append(f"{sub['start_time']} --> {sub['end_time']}")
        lines.append(sub["text"])
        lines.append("")
    return "\n".join(lines)


def translate_subtitle(
    text: str, source_lang: str, target_lang: str, silent: bool = False
) -> str:
    if not text or not text.strip():
        return text

    lines = text.split("\n")
    translated_lines = []

    for line in lines:
        if line.strip():
            translated_line = translate_text(line, source_lang, target_lang, silent)
            if translated_line:
                translated_lines.append(translated_line)
            else:
                translated_lines.append(line)
        else:
            translated_lines.append("")

    return "\n".join(translated_lines)


def detect_source_language_from_subs(subtitles: List[Dict]) -> str:
    all_text = " ".join([sub["text"] for sub in subtitles if sub["text"].strip()])
    return detect_language(all_text) or "en"


def translate_subtitle_entry(
    idx: int,
    text: str,
    source_lang: str,
    target_lang: str,
    silent: bool,
    rate_limiter: Optional[RateLimiter] = None,
) -> Tuple[int, str]:
    if not text or not text.strip():
        return idx, text

    translated_text = translate_text(
        text, source_lang, target_lang, silent, rate_limiter
    )
    if translated_text:
        return idx, translated_text
    return idx, text


def main():
    args = parse_arguments()

    if args.input is None:
        args.input = "input.srt"

    if args.output is None:
        base = os.path.splitext(os.path.basename(args.input))[0]
        args.output = f"{base}.{args.target}.srt"

    if not os.path.exists(args.input):
        print(f"Error: Input file not found: {args.input}", file=sys.stderr)
        sys.exit(1)

    try:
        with open(args.input, "r", encoding="utf-8") as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading input file: {str(e)}", file=sys.stderr)
        sys.exit(1)

    subtitles = parse_srt(content)
    if not subtitles:
        print("Error: No valid subtitles found in the file.", file=sys.stderr)
        sys.exit(1)

    if not args.silent:
        print(f"Loaded {len(subtitles)} subtitles from {args.input}")

    if args.source == "auto":
        source_lang = detect_source_language_from_subs(subtitles)
        if not args.silent:
            print(f"Detected source language: {source_lang}")
    else:
        source_lang = args.source

    target_lang = args.target

    if not args.silent:
        print(f"Translating from {source_lang} to {target_lang}...")

    completed = 0
    total = len(subtitles)
    subtitle_dict = {sub["index"]: sub for sub in subtitles}
    rate_limiter = RateLimiter(args.max_qps)

    def worker(idx, text):
        return translate_subtitle_entry(
            idx, text, source_lang, target_lang, args.silent, rate_limiter
        )

    executor = ThreadPoolExecutor(max_workers=args.workers)
    futures = {
        executor.submit(worker, sub["index"], sub["text"]): sub["index"]
        for sub in subtitles
    }

    try:
        for future in as_completed(futures):
            idx, translated = future.result()
            if idx in subtitle_dict:
                subtitle_dict[idx]["text"] = translated
            completed += 1
            if not args.silent:
                progress = completed / total * 100
                print(
                    f"\rProgress: {progress:.1f}% ({completed}/{total})",
                    end="",
                    flush=True,
                )
    except KeyboardInterrupt:
        print("\nInterrupted by user.")
        executor.shutdown(wait=False)
        raise SystemExit(130)

    if not args.silent:
        print()

    try:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(build_srt(subtitles))
        if not args.silent:
            print(f"Translated subtitles saved to {args.output}")
    except Exception as e:
        print(f"Error writing output file: {str(e)}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
