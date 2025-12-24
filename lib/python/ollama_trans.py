#!/usr/bin/env python3
# Translate Non-Chinese to Chinese or translate Chinese to English with Ollama.
# References:
# - https://qiita.com/KEINOS/items/3ab8879654e808d12791
# - https://github.com/xiaodaxia-2008/golden-dict-trans
# Authors: mistral.ai🧙‍♂️, scillidan🤡
# Usage:
# pip install requests
# python script.py --model <ollama_model> <input>

import requests
import json
import argparse
import re
import sys
import io

# Ensure stdout uses UTF-8 encoding
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

def is_chinese(text):
    # Check if the text contains Chinese characters
    for char in text:
        if '\u4e00' <= char <= '\u9fff':
            return True
    return False

def translate_text(text, model_name):
    # Set the Ollama API URL
    url = "http://localhost:11434/api/generate"

    # Determine the translation direction based on the input language
    if is_chinese(text):
        prompt = f'Translate the following Chinese sentence to English and return ONLY the following JSON format with no other text:\n{{"english": "<translation here>"}}\n\nChinese: {text}'
    else:
        prompt = f'Translate the following sentence to Chinese (Simplified, zh-cn) and return ONLY the following JSON format with no other text:\n{{"chinese": "<translation here>"}}\n\nSentence: {text}'

    # Set the request headers and data
    headers = {'Content-Type': 'application/json; charset=utf-8'}
    data = {
        'model': model_name,
        'prompt': prompt,
        'stream': False
    }

    # Send the request
    response = requests.post(url, headers=headers, data=json.dumps(data, ensure_ascii=False).encode('utf-8'))

    if response.status_code != 200:
        print(f"Error: {response.status_code}")
        print(response.text)
        return None, None

    # Parse the response
    response_data = response.json()
    output = response_data.get('response', '').strip()

    try:
        # Try to extract the JSON part from the raw output
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
        # Try to return the raw output
        return output, None

def main():
    if len(sys.argv) < 2:
        return  # Exit silently if no input is provided

    # Set up the command line argument parser
    parser = argparse.ArgumentParser(description='Translate text using Ollama API.')
    parser.add_argument('--model', type=str, default='llama3.1:8b', help='Model name to use for translation')
    parser.add_argument('text', type=str, help='Input text to translate')

    args = parser.parse_args()

    translated_text, target_language = translate_text(args.text, args.model)
    if translated_text:
        # Generate HTML output for GoldenDict
        html_output = f"""
{translated_text}
"""
        print(html_output)

if __name__ == "__main__":
    main()
