#!/bin/bash
# Cli shell for https://github.com/coqui-ai/TTS.
# Authors: mistral.ai🧙‍♂️, scillidan🤡
# Usage:
# Refer to https://scillidan-cheat.vercel.app/?search=TTS to install
# (Linux) ./tts_speaker.sh <speaker> <output.wav> "<text>"
# (Windows) bash tts_speaker.sh <speaker> <output.wav> "<text>"

set -e

# Define speaker abbreviations and full names
declare -A SPEAKERS=(
    ["SQ"]="Suad Qasim"          # female, low voice, 2
    ["AF"]="Ana Florence"        # female, low voice, 3
    ["ZA"]="Zacharie Aimilios"   #   male, low voice, 2
    ["EM"]="Eugenio Mataracı"    #   male, low voice, 3
    ["DSch"]="Dionisio Schuyler" #   male, low voice, 4
    ["VE"]="Viktor Eka"          #   male, low voice, 5
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

# Set base directory and virtual environment activation path
case "$OSTYPE" in
    linux-gnu*)
        VENV_ACT=".venv/bin/activate"
        BASE_DIR="$HOME"
        ;;
    msys|cygwin)
        VENV_ACT=".venv/Scripts/activate"
        BASE_DIR="/c/Users/$(whoami)"
        ;;
    *)
        echo "Unsupported OS: $OSTYPE"
        exit 1
        ;;
esac

# Cleanup function
cleanup() {
    if [[ -n "$VENV_ACT" ]]; then
        deactivate
    fi
    unset BASE_DIR
}

trap cleanup EXIT

# Navigate to the TTS directory
pushd "$BASE_DIR/Usr/OptAud/TTS" || exit 1

# Activate virtual environment
source "$VENV_ACT"

# Function to run TTS with speaker abbreviation
tts_speaker() {
    local speaker_abbr="$1"
    local output_file="$BASE_DIR/Downloads/$2"
    local input_text="$3"
    local language="en"
    local model="tts_models/multilingual/multi-dataset/xtts_v2"

    if [[ -z "${SPEAKERS[$speaker_abbr]}" ]]; then
        echo "Error: Unknown speaker abbreviation '$speaker_abbr'."
        echo "Available speakers:"
        for abbr in "${!SPEAKERS[@]}"; do
            echo "  $abbr: ${SPEAKERS[$abbr]}"
        done
        exit 1
    fi

    local speaker_name="${SPEAKERS[$speaker_abbr]}"
    tts --device cuda --model_name "$model" --language_idx "$language" --speaker_idx "$speaker_name" --text "$input_text" --out_path "$output_file"
}

# Main execution
tts_speaker "$1" "$2" "$3"

popd || exit 1
