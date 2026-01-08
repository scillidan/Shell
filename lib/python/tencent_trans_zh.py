# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "tencentcloud-sdk-python",
#     "langid"
# ]
# ///
#
# Tencent Cloud Translation API wrapper for translate Multi-language to Chinese or translate Chinese to English.
# Reference: https://github.com/LexsionLee/tencent-translate-for-goldendict
# Authors: DeepSeek🧙, scillidan🤡
# Install:
# 1. Get your API-Key from https://cloud.tencent.com/product/tmt
# 2. In environment, add:
# TENCENT_SECRET_ID=<YOUR_SECRET_ID>
# TENCENT_SECRET_KEY=<YOUR_SECRET_KEY>
# Useage:
# uv run file.py [--original-text] "<input>"
# echo <text> | uv run file.py [--stdin]
# cat file.txt | uv run file.py [--stdin]

import json
import sys
import os
import argparse
import textwrap
import unicodedata
import codecs
from typing import Optional, Tuple, List
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


def clean_surrogates(text: str) -> str:
    """Remove or replace surrogate characters."""
    if not text:
        return ""

    # Remove surrogate characters (U+D800 to U+DFFF)
    cleaned = ''.join(
        char for char in text
        if not ('\ud800' <= char <= '\udfff')
    )

    return cleaned


def read_input_with_encoding(fileobj):
    """Read input with proper encoding handling."""
    # Try UTF-8 first
    try:
        content = fileobj.buffer.read()
        return content.decode('utf-8')
    except UnicodeDecodeError:
        # Try UTF-16 if UTF-8 fails
        try:
            fileobj.buffer.seek(0)
            bom = fileobj.buffer.read(2)
            fileobj.buffer.seek(0)

            if bom == b'\xff\xfe' or bom == b'\xfe\xff':
                # UTF-16 with BOM
                return fileobj.buffer.read().decode('utf-16')
            else:
                # Try UTF-16 LE/BE without BOM
                try:
                    fileobj.buffer.seek(0)
                    return fileobj.buffer.read().decode('utf-16-le')
                except:
                    fileobj.buffer.seek(0)
                    return fileobj.buffer.read().decode('utf-16-be')
        except:
            # Fall back to latin-1 (never fails)
            fileobj.buffer.seek(0)
            return fileobj.buffer.read().decode('latin-1', errors='replace')


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
    parser.add_argument(
        '--original-text',
        action='store_true',
        help='Show the original input text after translation'
    )
    parser.add_argument(
        '--html',
        action='store_true',
        help='Output translation in HTML format'
    )
    parser.add_argument(
        '--stdin',
        action='store_true',
        help='Read input from stdin instead of arguments'
    )
    parser.add_argument(
        '--debug',
        action='store_true',
        help='Enable debug output'
    )
    return parser.parse_args()


def normalize_text(text: str) -> str:
    """
    Normalize text to handle special characters and encoding issues
    This helps prevent API errors caused by malformed input
    """
    if not text:
        return ""

    # First clean surrogate characters
    text = clean_surrogates(text)

    # Normalize Unicode characters
    try:
        normalized = unicodedata.normalize('NFKC', text)
    except:
        # If normalization fails, return the cleaned text
        normalized = text

    # Remove control characters that might cause issues
    problematic_chars = ['\x00', '\x01', '\x02', '\x03', '\x04', '\x05', '\x06', '\x07',
                       '\x08', '\x0b', '\x0c', '\x0e', '\x0f',
                       '\u200b', '\u200c', '\u200d', '\ufeff']  # Zero-width spaces and BOM
    for char in problematic_chars:
        normalized = normalized.replace(char, '')

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


def safe_json_dumps(obj, ensure_ascii=False):
    """Safely serialize JSON with surrogate character handling."""
    # First convert to JSON string
    try:
        json_str = json.dumps(obj, ensure_ascii=ensure_ascii)
    except UnicodeEncodeError:
        # If that fails, try with ensure_ascii=True
        json_str = json.dumps(obj, ensure_ascii=True)

    # Clean any remaining surrogates
    json_str = clean_surrogates(json_str)
    return json_str


def translate_text(
    text: str,
    source_lang: str,
    target_lang: str,
    silent: bool = False,
    debug: bool = False
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

    if debug:
        print(f"<!-- Normalized text: '{text[:100]}' -> '{normalized_text[:100]}' -->", file=sys.stderr)

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

        # Use safe JSON serialization
        json_str = safe_json_dumps(params, ensure_ascii=False)
        if debug:
            print(f"<!-- Request params: {json_str[:500]}... -->", file=sys.stderr)

        req.from_json_string(json_str)

        # Send request
        resp = client.TextTranslate(req)
        dict_resp = json.loads(resp.to_json_string())

        # Extract translation
        translated_text = dict_resp.get('TargetText')

        if translated_text:
            # Clean the response text as well
            translated_text = clean_surrogates(translated_text)
            return translated_text, target_lang
        else:
            if not silent:
                print(f"Warning: No translation returned for text: {text[:50]}...", file=sys.stderr)
            return None, None

    except TencentCloudSDKException as e:
        if not silent:
            print(f"Tencent Cloud API Error: {str(e)}", file=sys.stderr)

        # Provide more specific error messages
        error_code = str(e)
        if "AuthFailure" in error_code:
            if not silent:
                print("Authentication failed. Please check your SecretId and SecretKey.", file=sys.stderr)
        elif "RequestLimitExceeded" in error_code:
            if not silent:
                print("API rate limit exceeded. Please wait and try again.", file=sys.stderr)
        elif "FailedOperation.NoFreeAmount" in error_code:
            if not silent:
                print("Free quota exhausted. Please upgrade to paid service.", file=sys.stderr)

        return None, None

    except Exception as e:
        if not silent:
            print(f"Unexpected error: {str(e)}", file=sys.stderr)
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


def main():
    """Main execution function with improved error handling"""
    args = parse_arguments()

    # Read input text
    source_text = ''
    if args.stdin:
        # Read from stdin with encoding detection
        source_text = read_input_with_encoding(sys.stdin)
        # Remove trailing newlines
        if source_text.endswith('\n'):
            source_text = source_text.rstrip('\n')
    elif args.text:
        source_text = args.text
    else:
        try:
            # Try to read from stdin
            source_text = read_input_with_encoding(sys.stdin)
            # Remove trailing newlines
            if source_text.endswith('\n'):
                source_text = source_text.rstrip('\n')
        except Exception as e:
            if not args.silent:
                print(f"Error reading from stdin: {e}", file=sys.stderr)
            sys.exit(1)

    if not source_text:
        if not args.silent:
            print("Error: Empty input text", file=sys.stderr)
        sys.exit(1)

    if args.debug:
        print(f"<!-- Input text length: {len(source_text)} -->", file=sys.stderr)
        if source_text:
            print(f"<!-- First 200 chars: {repr(source_text[:200])} -->", file=sys.stderr)

    # Clean the source text of surrogate characters
    source_text = clean_surrogates(source_text)

    if args.debug and source_text != args.text and not args.stdin:
        print(f"<!-- Cleaned text (removed surrogates) -->", file=sys.stderr)

    # Detect source language
    source_lang = detect_language(source_text)
    if not source_lang:
        if not args.silent:
            print(f"Warning: Could not detect language for: {source_text[:50]}...", file=sys.stderr)
        source_lang = 'en'  # Default to English

    if args.debug:
        print(f"<!-- Detected language: {source_lang} -->", file=sys.stderr)

    # Determine translation direction
    actual_source, target_lang = determine_translation_direction(source_lang)

    if args.debug:
        print(f"<!-- Translation direction: {actual_source} -> {target_lang} -->", file=sys.stderr)

    # Perform translation
    translated_text, final_target_lang = translate_text(
        source_text,
        actual_source,
        target_lang,
        silent=args.silent,
        debug=args.debug
    )

    # Output result
    if translated_text:
        if args.html:
            # Generate clean HTML output
            lines = translated_text.split('\n')
            html_output = '''<div style="margin: 0; padding: 0;">'''

            for i, line in enumerate(lines):
                if line.strip():
                    html_output += f'<p style="margin: 0; padding: 0">{line}</p>'
                elif i < len(lines) - 1:  # Only add empty line if it's not the last line
                    html_output += '<p style="margin: 0; padding: 0">&nbsp;</p>'
                # If it's the last empty line, skip it

            html_output += '</div>'
            print(html_output)
        else:
            # Plain text output
            print(translated_text.strip())
    else:
        if not args.silent:
            print("Translation failed. Please check your API credentials and network connection.", file=sys.stderr)
        sys.exit(1)

    # Output the original input text if requested
    if args.original_text:
        if args.html:
            print(f'<div style="margin: 0; padding: 0;">{source_text}</div>')
        else:
            print(f"\n{source_text}")

if __name__ == "__main__":
    main()