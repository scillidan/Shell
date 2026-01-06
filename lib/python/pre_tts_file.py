# Text spliter.
# Authors: DeepSeek🧙‍♂️, scillidan🤡
# Usage: python file.py <input_file> [output_file] [max_length]

import sys
import os
import re
from pathlib import Path

def clean_text(text):
    """Remove unwanted characters: "", '', () from text."""
    if not text:
        return text

    # Remove quotes and parentheses
    text = re.sub(r'["\'"()\[\]{}]', '', text)

    # Remove multiple spaces
    text = re.sub(r'\s+', ' ', text)

    return text.strip()

def split_text(text, max_len=200):
    """Split text into segments <= max_len characters."""
    text = clean_text(text)
    if not text:
        return []

    if len(text) <= max_len:
        return [text]

    # Find best split point near middle
    mid = len(text) // 2
    punctuation = ',.;!?。，、；：？！'

    # Look for punctuation
    for i in range(mid, min(len(text), mid + 50)):
        if text[i] in punctuation:
            return split_text(text[:i+1], max_len) + split_text(text[i+1:], max_len)

    for i in range(mid - 1, max(-1, mid - 50), -1):
        if text[i] in punctuation:
            return split_text(text[:i+1], max_len) + split_text(text[i+1:], max_len)

    # Look for whitespace
    for i in range(mid, min(len(text), mid + 50)):
        if text[i].isspace():
            return split_text(text[:i], max_len) + split_text(text[i+1:], max_len)

    for i in range(mid - 1, max(-1, mid - 50), -1):
        if text[i].isspace():
            return split_text(text[:i], max_len) + split_text(text[i+1:], max_len)

    # Force split
    return split_text(text[:mid], max_len) + split_text(text[mid:], max_len)

def process_file(input_file, output_file=None, max_len=200):
    """Process input file, clean text, and split long lines."""
    with open(input_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    all_segments = []
    stats = {
        'total_lines': 0,
        'cleaned_lines': 0,
        'long_lines': 0,
        'segments': 0
    }

    for i, line in enumerate(lines, 1):
        original = line.rstrip('\n\r')
        clean = clean_text(original)

        if not clean:
            continue

        stats['total_lines'] += 1

        if clean != original.strip():
            stats['cleaned_lines'] += 1

        if len(clean) > max_len:
            stats['long_lines'] += 1

        segments = split_text(clean, max_len)
        all_segments.extend(segments)
        stats['segments'] += len(segments)

        # Show progress
        if i % 100 == 0:
            print(f"Processed {i}/{len(lines)} lines")

    # Print stats
    print(f"\n📊 Statistics:")
    print(f"  Total lines:      {stats['total_lines']}")
    print(f"  Cleaned lines:    {stats['cleaned_lines']}")
    print(f"  Lines to split:   {stats['long_lines']}")
    print(f"  Output segments:  {stats['segments']}")
    print(f"  Max length used:  {max_len} characters")

    # Check for warnings
    long_segments = [s for s in all_segments if len(s) > max_len]
    if long_segments:
        print(f"\n⚠️  Warning: {len(long_segments)} segments exceed {max_len} characters")
        for seg in long_segments[:3]:
            print(f"  - {len(seg)} chars: {seg[:50]}...")
    else:
        print(f"\n✅ All segments are under {max_len} characters")

    # Save output
    if output_file:
        with open(output_file, 'w', encoding='utf-8') as f:
            for segment in all_segments:
                f.write(segment + '\n')
        print(f"\n💾 Output saved to: {output_file}")

        # Show preview
        print(f"\n📄 First 5 segments:")
        for i, seg in enumerate(all_segments[:5], 1):
            preview = seg[:60] + ("..." if len(seg) > 60 else "")
            print(f"  {i}. ({len(seg):3d} chars) {preview}")

    return all_segments, stats

def main():
    if len(sys.argv) < 2:
        print("Usage: python file.py <input_file> [output_file] [max_length]")
        print("Example: python file.py input.txt output.txt 200")
        print("Note: The actual max_length used will be (specified_value - 1)")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None

    # max_len always -1
    if len(sys.argv) > 3:
        try:
            specified_max_len = int(sys.argv[3])
            max_len = specified_max_len - 1
            print(f"Info: Specified max_length: {specified_max_len}, will use: {max_len} (value-1)")
        except ValueError:
            print(f"Warning: Invalid max_length value: {sys.argv[3]}, using default 199")
            max_len = 199
    else:
        max_len = 199

    if not output_file:
        stem = Path(input_file).stem
        output_file = f"{stem}_clean_split.txt"

    if not os.path.exists(input_file):
        print(f"Error: File '{input_file}' not found!")
        sys.exit(1)

    print(f"Processing: {input_file}")
    print(f"Output:     {output_file}")
    print(f"Max length: {max_len} characters")
    print("Cleaning:   Removing \"\", '', (), [], {}, quotes, parentheses\n")

    process_file(input_file, output_file, max_len)

if __name__ == "__main__":
    main()