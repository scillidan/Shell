# Write by GPT-4o mini👨‍💻, scillidan🤡
# Purpose: Generate a timepoint list as text file format from audio files or a directory.
# It can be used to write timepoint list on video platform. And I used it for https://github.com/dyphire/mpv-scripts/blob/main/chapter-make-read.lua.
# Tools: python, ffprobe
# Usage: python file.py -i <file_1> <file_2> [-o <output>]

import os
import subprocess
import argparse

def check_ffprobe():
    """Check if ffprobe is installed."""
    try:
        subprocess.check_output(['ffprobe', '-version'])
    except FileNotFoundError:
        print("Error: ffprobe is not found. Please install FFmpeg and ensure it is in your PATH.")
        print("For installation instructions, visit: https://ffmpeg.org/download.html")
        exit(1)

def get_audio_metadata(file_path):
    command_duration = f'ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "{file_path}"'
    duration = float(subprocess.check_output(command_duration, shell=True).strip())

    command_title = f'ffprobe -v error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "{file_path}"'
    title = subprocess.check_output(command_title, shell=True).strip().decode('utf-8')

    return duration, title

def format_time(seconds):
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    seconds = seconds % 60
    milliseconds = int((seconds - int(seconds)) * 1000)
    seconds = int(seconds)

    return f"{hours:02}:{minutes:02}:{seconds:02}.{milliseconds:03}"

def collect_audio_files(input_paths):
    audio_files = []
    for path in input_paths:
        if os.path.isdir(path):
            for file in os.listdir(path):
                if file.lower().endswith(('.mp3', '.wav', '.flac', '.aac', 'm4a', 'm4b', 'ogg', 'opus')):
                    audio_files.append(os.path.join(path, file))
        elif os.path.isfile(path):
            audio_files.append(path)
    return audio_files

def generate_output_file_name(input_paths):
    # Use the first input path to determine the output file name
    first_input = input_paths[0]
    if os.path.isdir(first_input):
        return os.path.join(os.getcwd(), os.path.basename(first_input) + '.txt')
    else:
        return os.path.join(os.getcwd(), os.path.splitext(os.path.basename(first_input))[0] + '.txt')

def main(input_paths, output_file):
    audio_files = collect_audio_files(input_paths)
    total_duration = 0
    track_list = []

    for file in audio_files:
        duration, title = get_audio_metadata(file)
        start_time = format_time(total_duration)
        song_name = title if title else os.path.basename(file)
        track_list.append(f"{start_time} {len(track_list) + 1:02} - {song_name}")
        total_duration += duration

    # Write to the specified output file with UTF-8 encoding
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(track_list))

if __name__ == "__main__":
    check_ffprobe()  # Check for ffprobe before proceeding
    parser = argparse.ArgumentParser(description='Generate a track time list from audio files or a directory of audio files.')
    parser.add_argument('-i', '--input', nargs='+', help='List of audio files or directories', required=True)
    parser.add_argument('-o', '--output', help='Output file path')
    args = parser.parse_args()

    output_file = args.output if args.output else generate_output_file_name(args.input)
    main(args.input, output_file)
