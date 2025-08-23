#!/usr/bin/env python3
import subprocess
import argparse
from pathlib import Path
import sys
import json

# Supported audio extensions
AUDIO_EXTS = {'.mp3', '.wav', '.flac', '.aac', '.m4a', '.m4b', '.ogg', '.opus'}

def check_ffprobe():
	"""Check that ffprobe is installed and callable."""
	try:
		subprocess.run(['ffprobe', '-version'], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
	except (subprocess.CalledProcessError, FileNotFoundError):
		print("Error: ffprobe not found. Please install FFmpeg and ensure ffprobe is in your PATH.")
		print("Visit https://ffmpeg.org/download.html for installation instructions.")
		sys.exit(1)

def get_audio_metadata(file_path: Path):
	"""
	Get duration and title from an audio file using ffprobe.
	Uses one ffprobe call with JSON output.
	"""
	cmd = [
		'ffprobe', '-v', 'error', '-print_format', 'json',
		'-show_format', str(file_path)
	]
	try:
		proc = subprocess.run(cmd, capture_output=True, text=True, check=True)
		info = json.loads(proc.stdout)
		fmt = info.get('format', {})
		duration = float(fmt.get('duration', 0))
		tags = fmt.get('tags', {})
		title = tags.get('title') or file_path.stem
		return duration, title
	except Exception as e:
		print(f"Warning: Could not read metadata from '{file_path}': {e}")
		return 0, file_path.stem

def format_time(seconds: float) -> str:
	"""Format seconds as HH:MM:SS.mmm"""
	hours = int(seconds // 3600)
	minutes = int((seconds % 3600) // 60)
	secs = int(seconds % 60)
	millis = int((seconds - int(seconds)) * 1000)
	return f"{hours:02}:{minutes:02}:{secs:02}.{millis:03}"

def collect_audio_files(paths):
	"""
	Given a list of files/directories, collect all audio files.
	Recurses into directories.
	Returns sorted list of Path objects.
	"""
	files = []
	for p in paths:
		path = Path(p)
		if path.is_dir():
			files.extend(path.rglob('*'))
		elif path.is_file():
			files.append(path)
		else:
			print(f"Warning: Path '{p}' does not exist or is not accessible, skipping.")
	# Filter audio files by extension and sort naturally
	audio_files = [f for f in files if f.suffix.lower() in AUDIO_EXTS]
	return sorted(audio_files, key=lambda x: x.name.lower())

def generate_output_filename(input_paths):
	"""Create output filename based on first input argument."""
	first = Path(input_paths[0])
	if first.is_dir():
		return Path.cwd() / (first.name + '_timepoints.txt')
	else:
		stem = first.stem if first.is_file() else 'output'
		return Path.cwd() / (stem + '_timepoints.txt')

def main(input_paths, output_path):
	audio_files = collect_audio_files(input_paths)
	if not audio_files:
		print("No audio files found in the given input.")
		sys.exit(1)

	total_duration = 0
	lines = []

	for index, audio_file in enumerate(audio_files, start=1):
		duration, title = get_audio_metadata(audio_file)
		start_time = format_time(total_duration)
		lines.append(f"{start_time} {index:02d} - {title}")
		total_duration += duration

	# Write output file
	output_path = Path(output_path)
	output_path.write_text('\n'.join(lines), encoding='utf-8')
	print(f"Timepoint list generated: {output_path}")

if __name__ == '__main__':
	check_ffprobe()

	parser = argparse.ArgumentParser(
		description="Generate a timepoint list from audio files or directories."
	)
	parser.add_argument('-i', '--input', nargs='+', required=True, help="Input audio file(s) or directory(ies)")
	parser.add_argument('-o', '--output', help="Output filename (default based on input)")
	args = parser.parse_args()

	out_file = args.output if args.output else generate_output_filename(args.input)
	main(args.input, out_file)