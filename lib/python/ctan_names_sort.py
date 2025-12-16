# Purpose: Sort names in a text file and write the sorted names to a new file.
# Tools: Python
# Usage: python file.py -i <input_file> -o <output_file>

import os
import argparse
from natsort import natsorted

# Purpose: Sort names in a text file and write the sorted names to a new file.

def sort_names_in_file(input_file, output_file):
    """Reads a text file, sorts names in each line, and writes to a new file."""
    try:
        with open(input_file, 'r', encoding='utf-8') as infile:
            lines = infile.readlines()

        sorted_lines = []
        for line in lines:
            # Strip whitespace and split names by comma
            names = [name.strip() for name in line.split(',')]
            # Sort names using natural sorting
            sorted_names = natsorted(names)
            # Join sorted names back to a string
            sorted_lines.append(', '.join(sorted_names))

        with open(output_file, 'w', encoding='utf-8') as outfile:
            outfile.write('\n'.join(sorted_lines))

        print(f"Sorted names have been written to {output_file}.")

    except FileNotFoundError:
        print(f"Error: The file '{input_file}' was not found.")
    except IOError as e:
        print(f"Error: An IOError occurred. Details: {e}")

def main():
    parser = argparse.ArgumentParser(description='Sort names in a file.')
    parser.add_argument('-i', '--input', required=True, help='Input file path')
    parser.add_argument('-o', '--output', required=True, help='Output file path')

    args = parser.parse_args()

    sort_names_in_file(args.input, args.output)

if __name__ == '__main__':
    main()