#!/usr/bin/env python3
# Generate track timepoint list from audio files.
# Authors: GPT-4o mini👨‍💻, scillidan🤡
# Usage: python script.py -i <audio1> <audio2> [-o output.txt]

import os
import sys
import subprocess
import argparse
from typing import List, Tuple, Optional
from pathlib import Path

# Supported audio file extensions
AUDIO_EXTENSIONS = {'.mp3', '.wav', '.flac', '.aac', '.m4a', '.m4b', '.ogg', '.opus', '.wma'}

def check_ffprobe() -> None:
    """Check if ffprobe is available in system PATH."""
    try:
        subprocess.run(['ffprobe', '-version'],
                      capture_output=True, check=True)
    except (FileNotFoundError, subprocess.CalledProcessError):
        print("Error: ffprobe is not found or not working.")
        print("Please install FFmpeg from: https://ffmpeg.org/download.html")
        sys.exit(1)

def parse_ffprobe_output(file_path: Path, query: str) -> str:
    """
    Run ffprobe command and return output.

    Args:
        file_path: Path to audio file
        query: ffprobe show_entries query (e.g., 'format=duration')

    Returns:
        Stripped output string
    """
    cmd = [
        'ffprobe', '-v', 'error',
        '-show_entries', query,
        '-of', 'default=noprint_wrappers=1:nokey=1',
        str(file_path)
    ]

    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    return result.stdout.strip()

def get_audio_metadata(file_path: Path) -> Tuple[float, str]:
    """
    Get duration and title of an audio file.

    Args:
        file_path: Path to audio file

    Returns:
        Tuple of (duration in seconds, title or filename)
    """
    try:
        # Get duration
        duration_str = parse_ffprobe_output(file_path, 'format=duration')
        duration = float(duration_str) if duration_str else 0.0

        # Get title (fallback to filename)
        title = parse_ffprobe_output(file_path, 'format_tags=title')
        if not title:
            # Try other common tag names
            for tag in ['TITLE', 'title']:
                try:
                    title = parse_ffprobe_output(file_path, f'format_tags={tag}')
                    if title:
                        break
                except subprocess.CalledProcessError:
                    continue

        return duration, title or file_path.stem

    except (subprocess.CalledProcessError, ValueError) as e:
        print(f"Warning: Could not get metadata for {file_path.name}: {e}")
        return 0.0, file_path.stem

def format_time(seconds: float) -> str:
    """
    Format seconds to HH:MM:SS.mmm format.

    Args:
        seconds: Time in seconds

    Returns:
        Formatted time string
    """
    total_milliseconds = int(seconds * 1000)

    hours = total_milliseconds // 3_600_000
    minutes = (total_milliseconds % 3_600_000) // 60_000
    seconds_remain = (total_milliseconds % 60_000) // 1000
    milliseconds = total_milliseconds % 1000

    return f"{hours:02d}:{minutes:02d}:{seconds_remain:02d}.{milliseconds:03d}"

def collect_audio_files(input_paths: List[str]) -> List[Path]:
    """
    Collect all audio files from given paths.

    Args:
        input_paths: List of file or directory paths

    Returns:
        List of Path objects to audio files
    """
    audio_files = []

    for input_path in input_paths:
        path = Path(input_path)

        if not path.exists():
            print(f"Warning: Path does not exist: {input_path}")
            continue

        if path.is_file():
            if path.suffix.lower() in AUDIO_EXTENSIONS:
                audio_files.append(path)
            else:
                print(f"Warning: Not an audio file: {input_path}")

        elif path.is_dir():
            for file_path in path.rglob('*'):
                if file_path.is_file() and file_path.suffix.lower() in AUDIO_EXTENSIONS:
                    audio_files.append(file_path)

    return audio_files

def generate_tracklist(audio_files: List[Path]) -> List[str]:
    """
    Generate tracklist with timestamps.

    Args:
        audio_files: List of audio file paths

    Returns:
        List of formatted track entries
    """
    tracklist = []
    accumulated_time = 0.0

    for idx, file_path in enumerate(audio_files, 1):
        try:
            duration, title = get_audio_metadata(file_path)
            start_time = format_time(accumulated_time)

            # Format: HH:MM:SS.mmm 01 - Song Title
            track_entry = f"{start_time} {idx:02d} - {title}"
            tracklist.append(track_entry)

            accumulated_time += duration

            # Show progress
            print(f"Processed: {file_path.name} ({duration:.1f}s)")

        except Exception as e:
            print(f"Error processing {file_path.name}: {e}")
            continue

    return tracklist

def write_output(tracklist: List[str], output_path: Path) -> None:
    """
    Write tracklist to file.

    Args:
        tracklist: List of track entries
        output_path: Output file path
    """
    if not tracklist:
        print("Error: No tracks to write")
        return

    try:
        with output_path.open('w', encoding='utf-8') as f:
            f.write('\n'.join(tracklist))

        print(f"✓ Tracklist saved to: {output_path}")
        print(f"  Total tracks: {len(tracklist)}")

    except IOError as e:
        print(f"Error writing to {output_path}: {e}")
        sys.exit(1)

def main() -> None:
    """Main function."""
    parser = argparse.ArgumentParser(
        description='Generate timestamped tracklist from audio files.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s -i song1.mp3 song2.flac
  %(prog)s -i /path/to/album -o tracklist.txt
  %(prog)s -i file1.mp3 file2.wav -o chapters.txt
        """
    )

    parser.add_argument('-i', '--input', nargs='+', required=True,
                       help='Audio files or directories')
    parser.add_argument('-o', '--output',
                       help='Output file (default: auto-generated)')
    parser.add_argument('-v', '--verbose', action='store_true',
                       help='Show detailed information')

    args = parser.parse_args()

    # Check dependencies
    check_ffprobe()

    # Collect audio files
    if args.verbose:
        print("Collecting audio files...")

    audio_files = collect_audio_files(args.input)

    if not audio_files:
        print("Error: No audio files found")
        sys.exit(1)

    if args.verbose:
        print(f"Found {len(audio_files)} audio file(s)")

    # Generate output filename
    if args.output:
        output_path = Path(args.output)
    else:
        first_input = Path(args.input[0])
        if first_input.is_dir():
            base_name = first_input.name
        else:
            base_name = first_input.stem

        output_path = Path.cwd() / f"{base_name}_tracklist.txt"

    # Generate tracklist
    if args.verbose:
        print("Generating tracklist...")

    tracklist = generate_tracklist(audio_files)

    # Write output
    write_output(tracklist, output_path)

    # Show summary
    if args.verbose and tracklist:
        print("\nFirst few entries:")
        for entry in tracklist[:3]:
            print(f"  {entry}")
        if len(tracklist) > 3:
            print(f"  ... and {len(tracklist) - 3} more")

if __name__ == "__main__":
    main()