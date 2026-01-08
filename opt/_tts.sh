#!/bin/bash
# CLI shell for https://github.com/coqui-ai/TTS
# Authors: DeepSeek🧙‍♂️, scillidan🤡
# Dependencies: CUDA (tested on 12.4)
# Installation:
# git clone --depth=1 https://github.com/idiap/coqui-ai-TTS
# uv venv --python 3.10
# .venv\Scripts\activate.bat
# uv pip install torch --index-url https://download.pytorch.org/whl/cu124
# uv pip install -e .
# Usage:
# tts --list_models
# tts --model_name "tts_models/multilingual/multi-dataset/xtts_v2" --list_language_idxs
# tts --model_name "tts_models/multilingual/multi-dataset/xtts_v2" --list_speaker_idxs
# ./file.sh <speaker> <output.wav> "<text>"
# ./file.sh <speaker> <output_dir> --file <filename>
# (Windows) bash file.sh ...

set -e

model_path="tts_models/multilingual/multi-dataset/xtts_v2"
language="en"
flag="--device cuda"

declare -A SPEAKERS=(
    ["SQ"]="Suad Qasim"          # female, low voice, 2
    ["AF"]="Ana Florence"        # female, low voice, 3
    ["ZA"]="Zacharie Aimilios"   # male, low voice, 2
    ["EM"]="Eugenio Mataracı"    # male, low voice, 3
    ["DSch"]="Dionisio Schuyler" # male, low voice, 4
    ["VE"]="Viktor Eka"          # male, low voice, 5
    ["CD"]="Claribel Dervla"
    ["DS"]="Daisy Studious"
    ["GW"]="Gracie Wise"
    ["TE"]="Tammie Ema"
    ["AD"]="Alison Dietlinde"
    ["AN"]="Annmarie Nele"
    ["AA"]="Asya Anara"
    ["BS"]="Brenda Stern"
    ["GN"]="Gitta Nikolina"
    ["HU"]="Henriette Usha"
    ["SH"]="Sofia Hellen"
    ["TG"]="Tammy Grit"
    ["TA"]="Tanja Adelina"
    ["VJ"]="Vjollca Johnnie"
    ["AC"]="Andrew Chipper"
    ["BO"]="Badr Odhiambo"
    ["RM"]="Royston Min"
    ["AM"]="Abrahan Mack"
    ["AMi"]="Adde Michal"
    ["BSj"]="Baldur Sanjin"
    ["CG"]="Craig Gutsy"
    ["DB"]="Damien Black"
    ["GM"]="Gilberto Mathias"
    ["IU"]="Ilkin Urbano"
    ["KA"]="Kazuhiko Atallah"
    ["LM"]="Ludvig Milivoj"
    ["TD"]="Torcull Diarmuid"
    ["VM"]="Viktor Menelaos"
    ["NH"]="Nova Hogarth"
    ["MR"]="Maja Ruoho"
    ["UO"]="Uta Obando"
    ["LSz"]="Lidiya Szekeres"
    ["CM"]="Chandra MacFarland"
    ["SG"]="Szofi Granger"
    ["CH"]="Camilla Holmström"
    ["LSt"]="Lilya Stainthorpe"
    ["ZK"]="Zofija Kendrick"
    ["NM"]="Narelle Moon"
    ["BM"]="Barbora MacLean"
    ["AH"]="Alexandra Hisakawa"
    ["AMa"]="Alma María"
    ["RO"]="Rosemary Okafor"
    ["IB"]="Ige Behringer"
    ["FT"]="Filip Traverse"
    ["DC"]="Damjan Chapman"
    ["WC"]="Wulf Carlevaro"
    ["ADr"]="Aaron Dreschner"
    ["KD"]="Kumar Dahl"
    ["FS"]="Ferran Simen"
    ["XH"]="Xavier Hayasaka"
    ["LMor"]="Luis Moray"
    ["MRu"]="Marcos Rudaski"
)

# Store the original directory where the script was called from
ORIGINAL_DIR="$(pwd)"

case "$OSTYPE" in
    linux-gnu*)
        VENV_ACT=".venv/bin/activate"
        BASE_DIR="$HOME/Usr/OptAud/coqui-ai-TTS"
        ;;
    msys|cygwin)
        VENV_ACT=".venv/Scripts/activate"
        BASE_DIR="/c/Users/$USERNAME/Usr/OptAud/coqui-ai-TTS"
        ;;
    *)
        echo "Unsupported OS: $OSTYPE"
        exit 1
        ;;
esac

cleanup() {
    unset BASE_DIR
    unset VENV_ACT
    unset ORIGINAL_DIR
    trap - EXIT
}
trap cleanup EXIT

pushd "$BASE_DIR" || exit 1

if [ -f "$VENV_ACT" ]; then
    source "$VENV_ACT"
else
    echo "Virtual environment not found at: $VENV_ACT"
    exit 1
fi

tts_single() {
    local speaker_abbr="$1"
    local input_text="$2"
    local output_file="${3:-output.wav}"
    local model="$model_path"

    if [[ -z "${SPEAKERS[$speaker_abbr]}" ]]; then
        echo "Error: Unknown speaker abbreviation '$speaker_abbr'."
        echo "Available speakers:"
        for abbr in "${!SPEAKERS[@]}"; do
            echo "  $abbr: ${SPEAKERS[$abbr]}"
        done
        exit 1
    fi

    local speaker_name="${SPEAKERS[$speaker_abbr]}"
    tts $flag --model_name "$model" --language_idx "$language" --speaker_idx "$speaker_name" --text "$input_text" --out_path "$output_file"
    echo .
    echo "Generated: $output_file"
}

tts_batch() {
    local speaker_abbr="$1"
    local input_file="$2"
    local output_dir="${3:-output}"
    local model="$model_path"

    if [[ -z "${SPEAKERS[$speaker_abbr]}" ]]; then
        echo "Error: Unknown speaker abbreviation '$speaker_abbr'."
        echo "Available speakers:"
        for abbr in "${!SPEAKERS[@]}"; do
            echo "  $abbr: ${SPEAKERS[$abbr]}"
        done
        exit 1
    fi

    # Check if the file exists (handles both relative and absolute paths)
    if [ ! -f "$input_file" ]; then
        # Try looking in the original directory
        if [ -f "$ORIGINAL_DIR/$input_file" ]; then
            input_file="$ORIGINAL_DIR/$input_file"
        else
            echo "Error: Input file '$input_file' not found."
            echo "Also checked: '$ORIGINAL_DIR/$input_file'"
            exit 1
        fi
    fi

    mkdir -p "$output_dir"

    local speaker_name="${SPEAKERS[$speaker_abbr]}"
    local line_number=1

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines
        if [[ -z "$line" ]]; then
            echo "Skipping empty line $line_number"
            ((line_number++))
            continue
        fi

        # Skip lines starting with # (comments)
        if [[ "$line" =~ ^# ]]; then
            echo "Skipping comment line $line_number"
            ((line_number++))
            continue
        fi

        # Generate sequential filename (e.g., 0001.wav)
        local output_file=$(printf "%s/%04d.wav" "$output_dir" $line_number)

        echo "Line $line_number: ${line:0:50}..."
        tts $flag --model_name "$model" --language_idx "$language" --speaker_idx "$speaker_name" --text "$line" --out_path "$output_file"

        if [ $? -eq 0 ]; then
            echo "  ✓ Generated: $(basename "$output_file")"
        else
            echo "  ✗ Failed to generate: $(basename "$output_file")"
        fi

        ((line_number++))
    done < "$input_file"
    echo .
    echo "Total files generated: $((line_number-1))"
    echo "Output directory: $output_dir"
}

show_usage() {
    echo "Usage:"
    echo "  $0 <speaker> <output.wav> \"<text>\""
    echo "  $0 <speaker> <output_dir> --file <filename>"
    echo ""
    echo "Examples:"
    echo "  $0 SQ output.wav \"Hello world\""
    echo "  $0 SQ alice --file alice2_.txt"
    echo ""
    echo "Available speakers:"
    for abbr in "${!SPEAKERS[@]}"; do
        echo "  $abbr: ${SPEAKERS[$abbr]}"
    done
}

main() {
    if [ $# -eq 0 ]; then
        show_usage
        exit 1
    fi

    # Check for batch mode (must have at least 4 args and third is "--file")
    if [ $# -ge 4 ] && [ "$3" = "--file" ]; then
        local speaker="$1"
        local output_dir="$2"  # This is the output directory for batch mode
        local input_file="$4"  # The filename comes after --file

        tts_batch "$speaker" "$input_file" "$output_dir"
    elif [ $# -ge 2 ]; then
        # Single mode: speaker, text, [output_file]
        local speaker="$1"
        local text="$2"
        local output_file="${3:-output.wav}"  # Default to output.wav

        tts_single "$speaker" "$text" "$output_file"
    else
        echo "Error: Invalid arguments."
        echo ""
        show_usage
        exit 1
    fi
}

main "$@"

popd || exit 1