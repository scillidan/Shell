# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "requests"
# ]
# ///
#
# Translate Non-Chinese to Chinese or translate Chinese to English with Ollama.
# References:
# - https://qiita.com/KEINOS/items/3ab8879654e808d12791
# - https://github.com/xiaodaxia-2008/golden-dict-trans
# - https://ollama.com/blog/thinking
# Authors: mistral.ai🧙‍♂️, gpt-4o-mini🧙‍♂️, scillidan🤡
# Usage:
# uv run script.py --model <ollama_model> <input>
# uv run script.py --model <ollama_model> --think true --hidethinking <true|false> <input>
# Bugs:
# - Output jumbled code when translate English to Chinese in GoldenDict on Windows 10.

import requests
import json
import argparse
import re
import sys
import io
import unicodedata

# Ensure stdout uses UTF-8 encoding
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

def normalize_text(text):
    """Normalize text to handle special characters and encoding issues."""
    if not text:
        return ""
    normalized = unicodedata.normalize('NFKC', text)
    problematic_chars = ['\x00', '\x01', '\x02', '\x03', '\x04', '\x05', '\x06', '\x07',
                       '\x08', '\x0b', '\x0c', '\x0e', '\x0f']
    for char in problematic_chars:
        normalized = normalized.replace(char, '')
    normalized = ' '.join(normalized.split())
    return normalized.strip()

def is_chinese(text):
    """Check if the text contains Chinese characters."""
    for char in text:
        if '\u4e00' <= char <= '\u9fff':
            return True
    return False

def translate_text(text, model_name, think, hidethinking):
    """Translate text using Ollama API."""
    url = "http://localhost:11434/api/generate"
    if is_chinese(text):
        prompt = f'Translate the following Chinese sentence to English and return ONLY the following JSON format with no other text:\n{{"english": "<translation here>"}}\n\nChinese: {text}'
    else:
        prompt = f'Translate the following sentence to Chinese (Simplified, zh-cn) and return ONLY the following JSON format with no other text:\n{{"chinese": "<translation here>"}}\n\nSentence: {text}'

    headers = {'Content-Type': 'application/json; charset=utf-8'}
    data = {
        'model': model_name,
        'prompt': prompt,
        'think': think,
        'hidethinking': hidethinking,
        'stream': False
    }

    response = requests.post(url, headers=headers, data=json.dumps(data, ensure_ascii=False).encode('utf-8'))

    if response.status_code != 200:
        print(f"Error: {response.status_code}")
        print(response.text)
        return None, None

    response_data = response.json()
    output = response_data.get('response', '').strip()

    try:
        json_match = re.search(r'\{.*\}', output, re.DOTALL)
        if json_match:
            output = json_match.group(0)
        result = json.loads(output)
        if is_chinese(text):
            return result.get('english', ''), 'English'
        else:
            return result.get('chinese', ''), 'Chinese (Simplified)'
    except json.JSONDecodeError as e:
        print(f"Failed to parse JSON: {e}\nRaw output:\n{output}")
        return output, None

def main():
    if len(sys.argv) < 2:
        return

    parser = argparse.ArgumentParser(description='Translate text using Ollama API.')
    parser.add_argument('--model', type=str, default='llama3.1:8b', help='Model name to use for translation')
    parser.add_argument('--think', type=bool, default=False, help='Enable or disable thinking process (true or false)')
    parser.add_argument('--hidethinking', action='store_true', help='Hide thinking output')
    parser.add_argument('--silent', action='store_true', help='Suppress error messages')
    parser.add_argument('text', type=str, nargs='?', default='', help='Input text to translate')

    args = parser.parse_args()

    # Read from stdin if no text provided
    if not args.text:
        try:
            args.text = sys.stdin.read().strip()
        except Exception:
            if not args.silent:
                print("Error: No input text provided")
            sys.exit(1)

    if not args.text:
        if not args.silent:
            print("Error: Empty input text")
        sys.exit(1)

    # Normalize input text
    normalized_text = normalize_text(args.text)
    translated_text, target_language = translate_text(normalized_text, args.model, args.think, args.hidethinking)

    if translated_text:
        # Clean up translation
        clean_translation = translated_text.strip()
        # Simple, clean HTML output for GoldenDict
        html_output = f"{clean_translation}"
        print(html_output)

if __name__ == "__main__":
    main()
