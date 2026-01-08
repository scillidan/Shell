# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "stanza"
# ]
# ///

# English text Tagger with HTML color highlighting.
# Authors: DeepSeek🧙‍♂️, scillidan🤡
# Usage:
# python file.py "<text>" [options]
# echo "<text>" | python file.py [options]
# python file.py [options] < input.txt
# python file.py -i input.txt [options]
# Options:
# --gpu       Use GPU acceleration if available
# --cpu       Force CPU usage
# --verbose   Show detailed processing information
# --diagnose  Show GPU diagnosis information
# -i, --input Read from file instead of stdin
# -h, --help  Show this help message
# GPU Acceleration:
# - Recommended for texts > 1000 words (2-5x speedup)
# - Recommended for batch processing (10x+ speedup)
# - For short texts (<100 words), CPU is sufficient

import sys
import re
import stanza
import html
import io
import argparse
import os

def check_gpu_availability():
    try:
        import torch
        gpu_info = {}

        # Check CUDA
        gpu_info['CUDA available'] = torch.cuda.is_available()

        if gpu_info['CUDA available']:
            gpu_info['Device count'] = torch.cuda.device_count()
            gpu_info['Current device'] = torch.cuda.current_device()
            gpu_info['Device name'] = torch.cuda.get_device_name(0)
            gpu_info['CUDA version'] = torch.version.cuda
            gpu_info['PyTorch version'] = torch.__version__

            # Check if CUDA is actually working
            try:
                # Create a small tensor and move to GPU
                x = torch.tensor([1.0])
                x = x.cuda()
                gpu_info['Tensor test'] = "PASSED"
            except Exception as e:
                gpu_info['Tensor test'] = f"FAILED: {e}"

            return True, gpu_info
        else:
            return False, "No GPU detected by PyTorch"
    except ImportError:
        return False, "PyTorch not installed"
    except Exception as e:
        return False, f"Error checking GPU: {e}"

def clean_unicode_text(text):
    """Clean Unicode text, fix common encoding issues"""
    if not text:
        return text

    # Common Unicode punctuation replacements
    replacements = {
        '\u201c': '"',  # Left double quotation mark
        '\u201d': '"',  # Right double quotation mark
        '\u2018': "'",  # Left single quotation mark
        '\u2019': "'",  # Right single quotation mark
        '\u2013': '-',  # En dash
        '\u2014': '-',  # Em dash
        '\u2026': '...',# Ellipsis
        '\u00a0': ' ',  # Non-breaking space
        '\u00e2\u20ac\u2122': "'",  # Common mis-encoded quote
        '\u00e2\u20ac\u0153': '"',  # Common mis-encoded quote
        '\u00e2\u20ac\u009d': '"',  # Common mis-encoded quote
    }

    # Apply replacements
    for old, new in replacements.items():
        text = text.replace(old, new)

    # Remove invalid surrogate pairs
    text = re.sub(r'[\ud800-\udfff]', '', text)

    # Remove other control characters
    text = re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]', '', text)

    return text

def get_pos_color(pos_tag):
    """Return background color based on part of speech"""
    color_map = {
        'NOUN': '#e6f7e6',   # Noun - Light green
        'PROPN': '#e6f7e6',  # Proper noun - Light green
        'VERB': '#fff0e6',   # Verb - Light orange
        'AUX': '#fff0e6',    # Auxiliary verb - Light orange
        'ADJ': '#e6f2ff',    # Adjective - Light blue
        'ADV': '#f5e6ff',    # Adverb - Light purple
        'NUM': '#ffe6e6',    # Numeral - Light red
        'PRON': '#fffacd',   # Pronoun - Light yellow
        'DET': '#fffacd',    # Determiner - Light yellow
        'ADP': '#f8f8f8',    # Adposition - Light gray
        'CONJ': '#f8f8f8',   # Conjunction - Light gray
    }
    return color_map.get(pos_tag, '#f5f5f5')  # Other - Light gray

def get_input_text(args):
    """Get input text from multiple sources"""
    raw_text = ""

    # Case 1: From file
    if args.input:
        if not os.path.exists(args.input):
            print(f"Error: File not found: {args.input}", file=sys.stderr)
            sys.exit(1)

        try:
            with open(args.input, 'r', encoding='utf-8') as f:
                raw_text = f.read()
        except UnicodeDecodeError:
            try:
                with open(args.input, 'r', encoding='windows-1252') as f:
                    raw_text = f.read()
            except:
                print(f"Error: Cannot read file {args.input}", file=sys.stderr)
                sys.exit(1)
        except Exception as e:
            print(f"Error reading file: {e}", file=sys.stderr)
            sys.exit(1)

    # Case 2: From positional argument
    elif args.text:
        raw_text = args.text

    # Case 3: From stdin
    elif not sys.stdin.isatty():
        try:
            raw_bytes = sys.stdin.buffer.read()
            try:
                raw_text = raw_bytes.decode('utf-8')
            except UnicodeDecodeError:
                raw_text = raw_bytes.decode('windows-1252', errors='replace')
        except Exception as e:
            print(f"Error reading stdin: {e}", file=sys.stderr)
            return ""

    return raw_text

def escape_non_ascii(text):
    """Convert non-ASCII characters to HTML entities to avoid Windows console encoding issues"""
    result = []
    for char in text:
        if ord(char) < 128:
            result.append(char)
        else:
            result.append(f'&#{ord(char)};')
    return ''.join(result)

def process_paragraph(paragraph, nlp):
    """Process a single paragraph"""
    if not paragraph.strip():
        return []

    try:
        # Process paragraph
        doc = nlp(paragraph)
        
        all_sentences_html = []
        
        for sentence in doc.sentences:
            tokens = []
            for word in sentence.words:
                word_text = word.text

                # Convert non-ASCII characters to HTML entities
                escaped_word = escape_non_ascii(word_text)

                # No background for punctuation
                if word.upos == 'PUNCT':
                    tokens.append(escaped_word)
                else:
                    # Add color background for non-punctuation words
                    color = get_pos_color(word.upos)
                    tokens.append(f'<span style="background-color:{color}">{escaped_word}</span>')

            # Add spaces between tokens
            result = ' '.join(tokens)

            # Fix punctuation spacing issues
            result = re.sub(r'\s+([,.!?;:)\]}"\'])', r'\1', result)  # Remove space before punctuation
            result = re.sub(r'([([{"\'])\s+', r'\1', result)  # Remove space after opening punctuation
            result = re.sub(r'\s+-\s+', '-', result)  # Handle hyphens
            
            all_sentences_html.append(f"<p>{result}</p>")

        return all_sentences_html
    except Exception as e:
        # Return original paragraph if processing fails
        print(f"Error processing paragraph: {e}", file=sys.stderr)
        return [f"<p>{escape_non_ascii(paragraph)}</p>"]

def parse_args():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description='Tag English text with POS highlighting',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python file.py "Hello world!"
  python file.py -i input.txt
  echo "Hello world!" | python file.py
  python file.py < input.txt
  python file.py --gpu "Long text..."  # Use GPU acceleration
        """
    )

    # Input options
    input_group = parser.add_mutually_exclusive_group()
    input_group.add_argument('text', nargs='?', help='Text to process')
    input_group.add_argument('-i', '--input', help='Input file path')

    # Processing options
    parser.add_argument('--gpu', action='store_true', help='Use GPU if available')
    parser.add_argument('--cpu', action='store_true', help='Force CPU usage')
    parser.add_argument('--verbose', '-v', action='store_true', help='Verbose output')
    parser.add_argument('--diagnose', action='store_true', help='Show GPU diagnosis information')

    return parser.parse_args()

def main():
    """Main function"""
    # Parse arguments
    args = parse_args()

    # Set standard output encoding to UTF-8
    if hasattr(sys.stdout, 'buffer'):
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

    # Check GPU availability
    gpu_available, gpu_info = check_gpu_availability()

    if args.diagnose:
        print("GPU Diagnosis:", file=sys.stderr)
        if gpu_available:
            print("✓ GPU is available", file=sys.stderr)
            for key, value in gpu_info.items():
                print(f"  {key}: {value}", file=sys.stderr)
        else:
            print(f"✗ GPU is NOT available: {gpu_info}", file=sys.stderr)
        return

    # Get input text
    raw_text = get_input_text(args)

    if not raw_text:
        print("Error: No input text provided", file=sys.stderr)
        print("\nPlease provide text in one of these ways:", file=sys.stderr)
        print("  1. As argument: python file.py \"<text>\"", file=sys.stderr)
        print("  2. From file: python file.py -i file.txt", file=sys.stderr)
        print("  3. From stdin: echo \"Your text\" | python file.py", file=sys.stderr)
        parser.print_help()
        sys.exit(1)

    # Clean text
    cleaned_text = clean_unicode_text(raw_text)

    if cleaned_text != raw_text and args.verbose:
        print("Cleaned special characters from text", file=sys.stderr)

    # Configure stanza pipeline
    use_gpu = False

    if args.gpu:
        if gpu_available:
            use_gpu = True
            if args.verbose:
                print(f"✓ Using GPU: {gpu_info.get('Device name', 'N/A')}", file=sys.stderr)
        else:
            print(f"⚠ GPU requested but not available: {gpu_info}", file=sys.stderr)
            if "PyTorch not installed" in str(gpu_info):
                print("  Install PyTorch: uv pip install torch torchvision torchaudio", file=sys.stderr)
            use_gpu = False
    elif args.cpu:
        if args.verbose:
            print("Forcing CPU usage", file=sys.stderr)
    else:
        # Auto-detect
        if gpu_available:
            use_gpu = True
            if args.verbose:
                print(f"✓ Auto-detected GPU: {gpu_info.get('Device name', 'N/A')}", file=sys.stderr)

    # Try to import and check torch first
    try:
        import torch
        if args.verbose:
            print(f"PyTorch version: {torch.__version__}", file=sys.stderr)
            print(f"CUDA available: {torch.cuda.is_available()}", file=sys.stderr)
            if torch.cuda.is_available():
                print(f"CUDA version: {torch.version.cuda}", file=sys.stderr)
    except ImportError:
        if args.verbose:
            print("PyTorch not found, installing with CPU support only", file=sys.stderr)
        use_gpu = False

    # Initialize stanza with minimal processors
    try:
        if args.verbose:
            print("Initializing stanza pipeline...", file=sys.stderr)

        if use_gpu:
            nlp = stanza.Pipeline('en',
                                 processors='tokenize,pos',
                                 download_method=None,
                                 use_gpu=True)
            if args.verbose:
                print("✓ Stanza pipeline initialized with GPU support", file=sys.stderr)
        else:
            nlp = stanza.Pipeline('en',
                                 processors='tokenize,pos',
                                 download_method=None)
            if args.verbose:
                print("✓ Stanza pipeline initialized with CPU", file=sys.stderr)
    except Exception as e:
        if "model not found" in str(e).lower():
            if args.verbose:
                print("Downloading English model (only once)...", file=sys.stderr)
            stanza.download('en', processors='tokenize,pos')
            if use_gpu:
                nlp = stanza.Pipeline('en',
                                     processors='tokenize,pos',
                                     use_gpu=True)
                if args.verbose:
                    print("✓ Stanza pipeline initialized with GPU support", file=sys.stderr)
            else:
                nlp = stanza.Pipeline('en',
                                     processors='tokenize,pos')
                if args.verbose:
                    print("✓ Stanza pipeline initialized with CPU", file=sys.stderr)
        else:
            print(f"Failed to initialize stanza: {e}", file=sys.stderr)
            if "CUDA" in str(e):
                print("Trying CPU fallback...", file=sys.stderr)
                try:
                    nlp = stanza.Pipeline('en',
                                         processors='tokenize,pos',
                                         download_method=None)
                    if args.verbose:
                        print("✓ Stanza pipeline initialized with CPU (fallback)", file=sys.stderr)
                except Exception as e2:
                    print(f"CPU fallback also failed: {e2}", file=sys.stderr)
                    sys.exit(1)
            else:
                sys.exit(1)

    # Split text by newlines, preserve original line structure
    lines = cleaned_text.split('\n')
    output = []

    for i, line in enumerate(lines):
        if not line.strip():
            # Skip completely empty lines
            continue
        else:
            # Process each line and get list of sentence HTMLs
            sentence_htmls = process_paragraph(line, nlp)
            output.extend(sentence_htmls)

    # Output results - use UTF-8 encoding
    try:
        for line_html in output:
            if hasattr(sys.stdout, 'buffer'):
                sys.stdout.buffer.write(line_html.encode('utf-8'))
                sys.stdout.buffer.write(b'\n')
            else:
                print(line_html)
    except (UnicodeEncodeError, IOError) as e:
        if args.verbose:
            print(f"Output encoding error, using safe mode: {e}", file=sys.stderr)
        for line_html in output:
            safe_line = ''.join(c for c in line_html if ord(c) < 128)
            print(safe_line)

if __name__ == "__main__":
    main()