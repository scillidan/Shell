# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "tencentcloud-sdk-python",
#     "langid"
# ]
# ///
#
# Tencent Cloud Translation API wrapper for translate Non-Chinese to Chinese or translate Chinese to English.
# Reference: https://github.com/LexsionLee/tencent-translate-for-goldendict
# Authors: DeepSeek🧙, scillidan🤡
# Usage:
# 1. Get your API-Key from https://cloud.tencent.com/product/tmt
# 2. In environment, add:
#   - TENCENT_SECRET_ID=<YOUR_SECRET_ID>
#   - TENCENT_SECRET_KEY=<YOUR_SECRET_KEY>
# 3. uv run script.py <input_text>

import json
import sys
import os
import argparse
import textwrap
import unicodedata
from typing import Optional, Tuple
import langid

from tencentcloud.common import credential
from tencentcloud.common.profile.client_profile import ClientProfile
from tencentcloud.common.profile.http_profile import HttpProfile
from tencentcloud.common.exception.tencent_cloud_sdk_exception import TencentCloudSDKException
from tencentcloud.tmt.v20180321 import tmt_client, models


SECRET_ID = os.getenv("TENCENT_SECRET_ID")
SECRET_KEY = os.getenv("TENCENT_SECRET_KEY")
REGION = "ap-shanghai"
PROJECT_ID = 0

def parse_arguments() -> argparse.Namespace:
    """Parse command line arguments with improved error handling"""
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent('''
            Tencent Cloud Translation for GoldenDict
            Automatically detects language and translates:
            - Non-Chinese to Chinese
            - Chinese to English
            Supports languages listed at: https://cloud.tencent.com/document/api/551/15620
        ''')
    )
    parser.add_argument(
        'text',
        metavar='TEXT',
        type=str,
        nargs='?',
        default='',
        help='Text to translate (reads from stdin if not provided)'
    )
    parser.add_argument(
        '--silent',
        action='store_true',
        help='Suppress error messages (useful for GoldenDict integration)'
    )
    return parser.parse_args()


def normalize_text(text: str) -> str:
    """
    Normalize text to handle special characters and encoding issues
    This helps prevent API errors caused by malformed input
    """
    if not text:
        return ""

    # Normalize Unicode characters
    normalized = unicodedata.normalize('NFKC', text)

    # Remove control characters that might cause issues
    problematic_chars = ['\x00', '\x01', '\x02', '\x03', '\x04', '\x05', '\x06', '\x07',
                       '\x08', '\x0b', '\x0c', '\x0e', '\x0f']
    for char in problematic_chars:
        normalized = normalized.replace(char, '')

    # Collapse multiple whitespace
    normalized = ' '.join(normalized.split())

    return normalized.strip()


def detect_language(text: str) -> Optional[str]:
    """
    Detect language of input text with fallback mechanisms
    Returns language code compatible with Tencent Cloud API
    """
    if not text or not text.strip():
        return None

    try:
        # Use langid to detect language
        detected_lang, confidence = langid.classify(text)

        # Map to Tencent Cloud language codes
        lang_map = {
            'zh': 'zh',      # Chinese
            'en': 'en',      # English
            'ja': 'ja',      # Japanese
            'ko': 'ko',      # Korean
            'fr': 'fr',      # French
            'de': 'de',      # German
            'es': 'es',      # Spanish
            'it': 'it',      # Italian
            'ru': 'ru',      # Russian
            'pt': 'pt',      # Portuguese
            'ar': 'ar',      # Arabic
            'th': 'th',      # Thai
            'vi': 'vi',      # Vietnamese
            'ms': 'ms',      # Malay
        }

        # Return mapped language or default to English
        return lang_map.get(detected_lang, 'en')

    except Exception as e:
        # Fallback detection for robustness
        if any('\u4e00' <= char <= '\u9fff' for char in text):
            return 'zh'
        return 'en'  # Default to English


def initialize_tencent_client() -> Optional[tmt_client.TmtClient]:
    """
    Initialize Tencent Cloud Translation client with proper configuration
    Handles credential validation and client setup
    """
    if not SECRET_ID or not SECRET_KEY:
        raise ValueError("API credentials not configured. Please set SECRET_ID and SECRET_KEY.")

    try:
        # Initialize credentials
        cred = credential.Credential(SECRET_ID, SECRET_KEY)

        # Configure HTTP profile
        http_profile = HttpProfile()
        http_profile.endpoint = "tmt.tencentcloudapi.com"
        http_profile.req_timeout = 30  # 30 seconds timeout

        # Configure client profile
        client_profile = ClientProfile()
        client_profile.httpProfile = http_profile
        client_profile.signMethod = "TC3-HMAC-SHA256"  # Recommended signature method

        # Create client
        client = tmt_client.TmtClient(cred, REGION, client_profile)

        return client

    except TencentCloudSDKException as e:
        raise Exception(f"Failed to initialize Tencent Cloud client: {str(e)}")


def translate_text(
    text: str,
    source_lang: str,
    target_lang: str,
    silent: bool = False
) -> Tuple[Optional[str], Optional[str]]:
    """
    Translate text using Tencent Cloud Translation API
    Returns: (translated_text, target_language_code)
    """
    if not text or not text.strip():
        return None, None

    # Normalize input text
    normalized_text = normalize_text(text)
    if not normalized_text:
        return None, None

    try:
        # Initialize client
        client = initialize_tencent_client()

        # Prepare translation request
        req = models.TextTranslateRequest()
        params = {
            "SourceText": normalized_text,
            "Source": source_lang,
            "Target": target_lang,
            "ProjectId": PROJECT_ID
        }

        req.from_json_string(json.dumps(params))

        # Send request
        resp = client.TextTranslate(req)
        dict_resp = json.loads(resp.to_json_string())

        # Extract translation
        translated_text = dict_resp.get('TargetText')

        if translated_text:
            return translated_text, target_lang
        else:
            if not silent:
                print(f"Warning: No translation returned for text: {text[:50]}...")
            return None, None

    except TencentCloudSDKException as e:
        if not silent:
            print(f"Tencent Cloud API Error: {str(e)}")

        # Provide more specific error messages
        error_code = str(e)
        if "AuthFailure" in error_code:
            if not silent:
                print("Authentication failed. Please check your SecretId and SecretKey.")
        elif "RequestLimitExceeded" in error_code:
            if not silent:
                print("API rate limit exceeded. Please wait and try again.")
        elif "FailedOperation.NoFreeAmount" in error_code:
            if not silent:
                print("Free quota exhausted. Please upgrade to paid service.")

        return None, None

    except Exception as e:
        if not silent:
            print(f"Unexpected error: {str(e)}")
        return None, None


def determine_translation_direction(source_lang: str) -> Tuple[str, str]:
    """
    Determine translation direction based on source language
    Returns: (source_lang_code, target_lang_code)
    """
    # If Chinese, translate to English
    if source_lang == 'zh':
        return "zh", "en"
    # Otherwise, translate to Chinese (if supported) or to English
    else:
        # Languages that can be translated to Chinese
        supported_to_chinese = ['en', 'ja', 'ko', 'fr', 'de', 'es', 'it', 'ru', 'pt', 'ms', 'th', 'vi', 'ar']

        if source_lang in supported_to_chinese:
            return source_lang, "zh"
        else:
            # For other languages, fallback to English
            return source_lang, "en"


def generate_goldendict_output(original: str, translated: str, target_lang: str) -> str:
    """
    Generate HTML output formatted for GoldenDict display
    Inspired by the second script's clean output format
    """
    # Clean up translation
    clean_translation = translated.strip()

    # Language names for display
    lang_names = {
        'zh': 'Chinese',
        'en': 'English',
        'ja': 'Japanese',
        'ko': 'Korean',
        'fr': 'French',
        'de': 'German',
        'es': 'Spanish',
        'it': 'Italian',
        'ru': 'Russian',
        'pt': 'Portuguese',
        'ar': 'Arabic',
        'th': 'Thai',
        'vi': 'Vietnamese',
        'ms': 'Malay'
    }

    display_lang = lang_names.get(target_lang, target_lang.upper())

    # Simple, clean HTML output
    html_output = f"{clean_translation}"
    return html_output


def main():
    """Main execution function with improved error handling"""
    args = parse_arguments()

    # Read input text
    if args.text:
        source_text = args.text
    else:
        # Read from stdin (GoldenDict pipes text this way)
        try:
            source_text = sys.stdin.read().strip()
        except Exception:
            if not args.silent:
                print("Error: No input text provided")
            sys.exit(1)

    if not source_text:
        if not args.silent:
            print("Error: Empty input text")
        sys.exit(1)

    # Detect source language
    source_lang = detect_language(source_text)
    if not source_lang:
        if not args.silent:
            print(f"Warning: Could not detect language for: {source_text[:50]}...")
        source_lang = 'en'  # Default to English

    # Determine translation direction
    actual_source, target_lang = determine_translation_direction(source_lang)

    # Perform translation
    translated_text, final_target_lang = translate_text(
        source_text,
        actual_source,
        target_lang,
        silent=args.silent
    )

    # Output result
    if translated_text:
        # Format for GoldenDict
        output_html = generate_goldendict_output(source_text, translated_text, final_target_lang)
        print(output_html)
    else:
        if not args.silent:
            print("Translation failed. Please check your API credentials and network connection.")
        sys.exit(1)


if __name__ == "__main__":
    main()