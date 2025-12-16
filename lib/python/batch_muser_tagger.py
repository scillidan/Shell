# Refer to https://scillidan.github.io/notes/web-app/muser.html
# Write by GPT-4o mini 🧙, scillidan 🤡

import os
import numpy as np
import json
from musicnn.extractor import extractor

input_path = 'app/assets/music/'
output_path = 'app/assets/music-tags/'

def exportJSON(taggram, tags, output_file):
    """Export the taggram and tags to a JSON file."""
    taggram_list = taggram.T.tolist()
    tags_object = {tags[i]: taggram_list[i] for i in range(len(tags))}
    with open(output_file, 'w') as outfile:
        json.dump(tags_object, outfile)

def process_files(input_path, output_path):
    """Process all MP3 files in the input directory."""
    for file_name in os.listdir(input_path):
        if file_name.endswith('.mp3'):
            file_base_name = os.path.splitext(file_name)[0]
            input_file = os.path.join(input_path, file_name)
            output_file = os.path.join(output_path, f"{file_base_name}.json")

            print(f"Generating MSD tags for {file_name}...")
            MSD_taggram, MSD_tags, _ = extractor(input_file, model='MSD_musicnn', input_overlap=1, extract_features=True)

            print(f"Generating MTT tags for {file_name}...")
            MTT_taggram, MTT_tags, _ = extractor(input_file, model='MTT_musicnn', input_overlap=1, extract_features=True)

            taggram = np.concatenate((MSD_taggram, MTT_taggram), axis=1)
            tags = np.concatenate((MSD_tags, MTT_tags))

            # Commented out the display of the taggram
            # showTags(taggram, tags)

            exportJSON(taggram, tags, output_file)
            print(f"Tags exported to {output_file}")

if __name__ == "__main__":
    process_files(input_path, output_path)