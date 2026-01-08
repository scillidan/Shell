# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "stanza"
# ]
# ///

# Authors: DeepSeek🧙‍♂️, scillidan🤡
# uv run file.py "<input>"
# echo <text> | uv run file.py --stdin
# cat file.txt | uv run file.py --stdin

import sys
import stanza

# Download the English model (only needed once)
try:
    nlp = stanza.Pipeline('en', download_method=None)
except Exception as e:
    if "model not found" in str(e).lower() or "resource not found" in str(e).lower():
        print("Downloading English model (one-time operation)...", file=sys.stderr)
        stanza.download('en')
        nlp = stanza.Pipeline('en')
    else:
        raise

# Get input text with proper Unicode handling
if len(sys.argv) > 1:
    # Read from command line argument
    input_text = sys.argv[1]
elif not sys.stdin.isatty():
    # Read from stdin with proper encoding handling
    if sys.platform == "win32":
        # Windows may need special handling
        import io
        sys.stdin = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8', errors='replace')
    input_text = sys.stdin.read()
else:
    print("Error: No input text provided", file=sys.stderr)
    print("Usage: uv run file.py \"<text>\"", file=sys.stderr)
    print("       echo <text> | uv run file.py", file=sys.stderr)
    print("       cat file.txt | uv run file.py", file=sys.stderr)
    sys.exit(1)

# Process the text
doc = nlp(input_text)

# Output as plaintext (one sentence per line)
for sentence in doc.sentences:
    print(sentence.text)