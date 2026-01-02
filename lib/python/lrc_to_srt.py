# Base on https://github.com/HUYDGD/lrc2srt/blob/main/lrc2srt.py
# Authors: perplexity.ai🧙‍♂️, scillidan🤡
# Usage:
# python script.py <lrc> <srt>

import os
import re
import sys

def parse_lrc_timestamp(timestamp):
    try:
        minutes, seconds = timestamp.split(':')
        seconds, milliseconds = seconds.split('.')
        minutes, seconds, milliseconds = int(minutes), int(seconds), int(milliseconds)
        return minutes * 60 + seconds + milliseconds / 100
    except ValueError:
        return None

def format_time(seconds):
    hours = int(seconds) // 3600
    minutes = (int(seconds) % 3600) // 60
    seconds_part = int(seconds) % 60
    milliseconds = int(round((seconds - int(seconds)) * 1000))
    return f"{hours:02d}:{minutes:02d}:{seconds_part:02d},{milliseconds:03d}"

def lrc_to_srt(lrc_file_path, srt_file_path):
    with open(lrc_file_path, 'r', encoding='utf-8') as lrc_file:
        lrc_content = lrc_file.read()

    subs = []
    pattern = r'\[(\d+:\d+\.\d+)\](.*)'
    matches = re.findall(pattern, lrc_content)

    for idx, match in enumerate(matches):
        timestamp, text = match
        start_time = parse_lrc_timestamp(timestamp)
        if start_time is not None:
            end_time = parse_lrc_timestamp(matches[idx + 1][0]) if idx + 1 < len(matches) else start_time + 1
            block = f"{len(subs) + 1}\n{format_time(start_time)} --> {format_time(end_time)}\n{text.strip()}"
            subs.append(block)

    # Join blocks with exactly one blank line between, NO trailing blank line
    srt_content = "\n\n".join(subs).rstrip('\n')

    with open(srt_file_path, 'w', encoding='utf-8') as srt_file:
        srt_file.write(srt_content)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <input_file> <output_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    if not os.path.isfile(input_file):
        print(f"Error: Input file '{input_file}' not found.")
        sys.exit(1)

    lrc_to_srt(input_file, output_file)
    print(f"Converted '{os.path.basename(input_file)}' to '{os.path.basename(output_file)}'")
