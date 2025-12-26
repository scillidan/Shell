# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "requests",
#     "langdetect"
# ]
# ///
#
# Translate Non-Chinese to Chinese or translate Chinese to English with Ollama.
# References:
# - https://qiita.com/KEINOS/items/3ab8879654e808d12791
# - https://github.com/xiaodaxia-2008/golden-dict-trans
# Model: https://ollama.com/zongwei/gemma3-translator
# Authors: mistral.ai🧙‍♂️, scillidan🤡
# Usage:
# uv run script.py <input>
# uv run script.py --debug <input>
# Bugs:
# - Output jumbled code when translate English to Chinese in GoldenDict on Windows 10.

import requests
import json
import argparse
import re
import sys
import io
import unicodedata
from langdetect import detect

# Ensure stdout uses UTF-8 encoding
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

# Set the model name here
MODEL_NAME = 'zongwei/gemma3-translator:4b'

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

def detect_language(text):
    try:
        return detect(text)
    except:
        return "unknown"

def translate_text(text, debug=False):
    # Normalize input text first
    normalized_text = normalize_text(text)
    if debug and text != normalized_text:
        print(f"<!-- Normalized text: '{text}' -> '{normalized_text}' -->")

    url = "http://localhost:11434/api/generate"
    if is_chinese(normalized_text):
        prompt = f'Translate from Chinese to English:\n{{"english": "<translation here>"}}\n\nChinese: {normalized_text}'
    else:
        lang = detect_language(normalized_text)
        prompt = f'Translate from {lang} to Chinese:\n{{"chinese": "<translation here>"}}\n\nSentence: {normalized_text}'

    headers = {'Content-Type': 'application/json; charset=utf-8'}
    data = {
        'model': MODEL_NAME,
        'prompt': prompt,
        'stream': False
    }

    response = requests.post(url, headers=headers, data=json.dumps(data, ensure_ascii=False).encode('utf-8'))

    if response.status_code != 200:
        if debug:
            print(f"<!-- API Error: {response.status_code}, Response: {response.text} -->")
        return text, None  # Return original text if API fails

    response_data = response.json()
    output = response_data.get('response', '').strip()

    if debug:
        print(f"<!-- Raw API Response: {output} -->")  # Debug: Print raw response

    try:
        json_match = re.search(r'\{.*\}', output, re.DOTALL)
        if json_match:
            output = json_match.group(0)
        result = json.loads(output)
        if is_chinese(normalized_text):
            translated_text = result.get('english', output)
        else:
            translated_text = result.get('chinese', output)

        # Normalize the translated text as well
        normalized_translation = normalize_text(translated_text)
        if debug and translated_text != normalized_translation:
            print(f"<!-- Normalized translation: '{translated_text}' -> '{normalized_translation}' -->")

        if is_chinese(normalized_text):
            return normalized_translation, 'English'
        else:
            return normalized_translation, 'Chinese (Simplified)'
    except json.JSONDecodeError:
        # Normalize the raw output if JSON parsing fails
        normalized_output = normalize_text(output)
        return normalized_output, None

def main():
    if len(sys.argv) < 2:
        return

    parser = argparse.ArgumentParser(description='Translate text using Ollama API.')
    parser.add_argument('--debug', action='store_true', help='Enable debug output')
    parser.add_argument('text', type=str, help='Input text to translate')

    args = parser.parse_args()

    translated_text, _ = translate_text(args.text, args.debug)
    if translated_text:
        print(f"{translated_text}")

if __name__ == "__main__":
    main()