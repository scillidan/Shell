#!/usr/bin/env python3
# Translate Non-Chinese to Chinese or translate Chinese to English with Ollama.
# References:
# - https://qiita.com/KEINOS/items/3ab8879654e808d12791
# - https://github.com/xiaodaxia-2008/golden-dict-trans
# Model: https://ollama.com/zongwei/gemma3-translator
# Authors: mistral.ai🧙‍♂️, scillidan🤡
# Usage:
# pip install requests langdetect
# python script.py <input>
# python script.py --debug <input>

import requests
import json
import argparse
import re
import sys
import io
from langdetect import detect

# Ensure stdout uses UTF-8 encoding
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

# Set the model name here
MODEL_NAME = 'zongwei/gemma3-translator:4b'

def is_chinese(text):
    # Check if the text contains Chinese characters
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
    url = "http://localhost:11434/api/generate"
    if is_chinese(text):
        prompt = f'Translate from Chinese to English:\n{{"english": "<translation here>"}}\n\nChinese: {text}'
    else:
        lang = detect_language(text)
        prompt = f'Translate from {lang} to Chinese:\n{{"chinese": "<translation here>"}}\n\nSentence: {text}'

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
        if is_chinese(text):
            return result.get('english', output), 'English'
        else:
            return result.get('chinese', output), 'Chinese (Simplified)'
    except json.JSONDecodeError:
        return output, None  # Return raw output if JSON parsing fails

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