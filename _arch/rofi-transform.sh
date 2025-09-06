#!/usr/bin/env bash
# Write by GPT-4o mini🧙‍♂️, scillidan🤡
# Depend on https://github.com/scillidan/Keypirinha-PuzzTools/blob/main/transforms.py

for cmd in rofi xclip python3 notify-send; do
	if ! command -v "$cmd" >/dev/null 2>&1; then
		echo "Error: $cmd is not installed." >&2
		exit 1
	fi
done

input=$(xclip -selection clipboard -o 2>/dev/null)
if [[ -z "$input" ]]; then
	notify-send -u critical "Convert Error" "Clipboard is empty."
	exit 1
fi

options=(
	"case.lowercase"
	"case.uppercase"
	"case.titlecase"
	"case.kebabcase"
	"case.snakecase"
	"case.camelcase"
	"case.pascalcase"
	"case.nocase"
	"format kebab"
	"nutrimatic.from ANSWERIZE"
	"nutrimatic.add A* between"
	"nutrimatic.add ?"
	"nutrimatic.from enumeration"
	"sort.alphabetical"
	"sort.by length"
	"sort.reverse"
	"tool.2github commits atom"
	"tool.2github releases atom"
	"tool.2github raw url"
	"tool.2ghcli url"
	"tool.2unix url"
	"tool.22unix url"
	"tool.2windows url"
	"tool.2windows url2"
	"tool.lobechat assistants"
	"tool.linebreak 2comma"
	"tool.markdown link"
	"alphabet"
	"answerize"
	"length"
	"reverse"
	"rotate"
	"transpose"
	"unique"
)

choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Select transform:")

if [[ -z "$choice" ]]; then
	notify-send "Conversion Cancelled" "No transform selected"
	exit 0
fi

# Call python with input and choice
result=$(python3 -c "
import re
import sys

data = '''$input'''

_CASES = {
    'lowercase': str.lower,
    'uppercase': str.upper,
    'titlecase': lambda x: x.title(),
    'kebabcase': lambda x: re.sub(r'\\s|(\\B)([A-Z])', r'-\\2', x).lower(),
    'snakecase': lambda x: re.sub(r'\\s|(\\B)([A-Z])', r'_\\2', x).lower(),
    'camelcase': lambda x: x[0].lower() + re.sub(r'\\s|(\\B)([A-Z])', r'\\2', x)[1:] if x else x,
    'pascalcase': lambda x: re.sub(r'\\s|(\\B)([A-Z])', r'\\2', x),
    'nocase': str,
}

def make_grid_transform(grid_transform):
    def transform(d):
        has_tab = '\\t' in d
        new_line = '\\r\\n' if '\\r\\n' in d else '\\n'
        grid = [l.split('\\t') if has_tab else list(l) for l in d.split(new_line)]
        new_grid = list(grid_transform(grid))
        return new_line.join(('\\t' if has_tab else '').join(line) for line in new_grid)
    return transform

_NUTRIMATICS = {
    'from ANSWERIZE': lambda x: x.lower().replace('?', 'A'),
    'add A* between': lambda x: 'A*' + 'A*'.join(x) + 'A*',
    'add ?': lambda x: ''.join(f'{c}?' for c in x),
    'from enumeration': lambda x: ' '.join(f'A{{{n}}}' for n in re.findall(r'\\d+', x)),
}

_SORTS = {
    'alphabetical': lambda x: '\\n'.join(sorted(x.split('\\n'))),
    'by length': lambda x: '\\n'.join(sorted(x.split('\\n'), key=len)),
    'reverse': lambda x: '\\n'.join(reversed(x.split('\\n'))),
}

_TOOLS = {
    '2github commits atom': lambda x: re.sub(r'https://github.com/([^/]+)/([^/]+)(?:/.*)?', r'https://github.com/\\1/\\2/commits.atom', x),
    '2github releases atom': lambda x: re.sub(r'https://github.com/([^/]+)/([^/]+)(?:/.*)?', r'https://github.com/\\1/\\2/releases.atom', x),
    '2github raw url': lambda x: re.sub(r'https://github.com/([^/]+)/([^/]+)/blob/([^/]+)/(.+)', r'https://raw.githubusercontent.com/\\1/\\2/refs/heads/\\3/\\4', x),
    '2ghcli url': lambda x: re.sub(r'https://github.com/([^/]+)/([^/]+)(?:/.*)?', r'\\1/\\2', x),
    '2unix url': lambda x: x.replace('\\\\', '/'),
    '22unix url': lambda x: x.replace('\\\\\\\\', '/'),
    '2windows url': lambda x: x.replace('/', '\\\\'),
    '2windows url2': lambda x: x.replace('\\\\', '\\\\\\\\'),
    'lobechat assistants': lambda x: re.sub(r'https://lobehub.com/assistants/(.*)', r'https://lobechat.com/discover/assistant/\\1', x),
    'linebreak 2comma': lambda x: ','.join(sorted(set(x.split()), key=int)),
    'markdown link': lambda x: '[{}]({})'.format(*[line.strip() for line in x.splitlines()]),
}

def format_kebab(x):
    s = re.sub(r'[^A-Za-z0-9]+', '-', x)
    s = re.sub(r'-+', '-', s)
    s = s.strip('-')
    return s

TRANSFORMS = {
    'case': _CASES,
    'nutrimatic': _NUTRIMATICS,
    'sort': _SORTS,
    'tool': _TOOLS,
    'format kebab': format_kebab,
    'alphabet': lambda _: 'abcdefghijklmnopqrstuvwxyz',
    'answerize': lambda x: re.sub('[^A-Z0-9]', '', x.upper()),
    'length': len,
    'reverse': lambda x: x[::-1],
    'rotate': make_grid_transform(lambda x: zip(*reversed(x))),
    'transpose': make_grid_transform(lambda x: zip(*x)),
    'unique': lambda x: ''.join(sorted(set(x))),
}

choice = '$choice'

def get_transform(choice):
    parts = choice.split('.', 1)
    if len(parts) == 2:
        group_key, sub_key = parts
        group = TRANSFORMS.get(group_key)
        if group is None:
            print('Invalid transform group', file=sys.stderr)
            sys.exit(1)
        if isinstance(group, dict):
            func = group.get(sub_key)
            if func is None:
                print('Invalid transform', file=sys.stderr)
                sys.exit(1)
            return func
        else:
            print('Invalid transform type', file=sys.stderr)
            sys.exit(1)
    else:
        func = TRANSFORMS.get(choice)
        if func is None:
            print('Invalid transform', file=sys.stderr)
            sys.exit(1)
        return func

f = get_transform(choice)

try:
    # Determine category for line-by-line processing
    if '.' in choice:
        category = choice.split('.')[0]
    else:
        category = choice

    # Categories where line-by-line processing makes sense
    line_by_line_categories = ['case', 'format kebab', 'nutrimatic', 'tool', 'answerize', 'alphabet', 'reverse', 'unique']

    if category in line_by_line_categories:
        lines = data.splitlines()
        transformed_lines = [f(line) for line in lines]
        out = '\n'.join(transformed_lines)
    else:
        # For other transforms like sort, length, rotate, transpose, apply on whole text
        out = f(data)

    # length transform returns int, convert to str
    if not isinstance(out, str):
        out = str(out)

except Exception as e:
    print(f'Error: {e}', file=sys.stderr)
    sys.exit(1)

print(out)
")

if [[ $? -ne 0 || -z "$result" ]]; then
	notify-send -u critical "Transform Error" "Failed to apply transform."
	exit 1
fi

# Copy result to clipboard
echo -n "$result" | xclip -selection clipboard

# Notify user
notify-send "Transform applied" "$result"
