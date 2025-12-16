# Refer to https://github.com/TrueMyst/BeatPrints
# and https://scillidan.github.io/notes/script/beatprints.html
# Write by GPT-4o mini 🧙, scillidan 🤡

# How to use
# python this.py "<your_csv>"

import os
import dotenv
import csv
import argparse
import time
import requests
from BeatPrints import lyrics, poster, spotify

dotenv.load_dotenv()

# Spotify credentials
CLIENT_ID = os.getenv("SPOTIFY_CLIENT_ID")
CLIENT_SECRET = os.getenv("SPOTIFY_CLIENT_SECRET")

# Initialize components
ly = lyrics.Lyrics()
ps = poster.Poster("./")
sp = spotify.Spotify(CLIENT_ID, CLIENT_SECRET)

# Function to process tracks from CSV
def process_tracks_from_csv(csv_file):
    with open(csv_file, mode='r', newline='', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            track_name = row['track-name']
            artist_name = row['artist-name']
            search_query = f"{track_name} - {artist_name}"

            # Search for the track and fetch metadata
            try:
                search = sp.get_track(search_query, limit=1)

                if search:
                    # Pick the first result
                    metadata = search[0]

                    # Get lyrics and determine if the track is instrumental
                    lyrics = ly.get_lyrics(metadata)

                    # Use the placeholder for instrumental tracks; otherwise, select specific lines
                    highlighted_lyrics = (
                        lyrics if ly.check_instrumental(metadata) else ly.select_lines(lyrics, "1-5")
                    )

                    # Generate the track poster
                    ps.track(metadata, highlighted_lyrics)
                else:
                    print(f"No results found for: {search_query}")

            except requests.exceptions.RequestException as e:
                print(f"Network error occurred: {e}")
            except Exception as e:
                print(f"An error occurred while processing {search_query}: {e}")

            # Delay to avoid excessive requests
            time.sleep(1)  # Adjust the delay as necessary

# Main function to handle command-line arguments
def main():
    parser = argparse.ArgumentParser(description="Process tracks from a CSV file.")
    parser.add_argument("csv_file", nargs='?', default='your_tracks.csv', 
                        help="CSV file containing track and artist names (default: your_tracks.csv)")
    
    args = parser.parse_args()
    process_tracks_from_csv(args.csv_file)

if __name__ == "__main__":
    main()