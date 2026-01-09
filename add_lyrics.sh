#!/bin/zsh
set -euo pipefail

candidates=()
for f in *.mp3(N); do
  [[ -f "m4a/${f%.mp3}.m4a" ]] || candidates+=("$f")
done

if (( ${#candidates} == 0 )); then
  echo "All MP3 files are already converted."
  exit 0
fi

file=$(print -rl -- "${candidates[@]}" | fzf --prompt="Select an MP3 file: ")

basename="${file%.mp3}"

# if m4a directory doesn't exist, create it
mkdir -p m4a


# check if lyrics file exists
if [[ ! -f "$basename.txt" ]]; then
  echo "Lyrics file '$basename.txt' not found. Exiting."
  exit 1
fi

# if the output file exists, exit
if [[ -f "m4a/$basename.m4a" ]]; then
  echo "Output file 'm4a/$basename.m4a' already exists. Exiting."
  exit 1
fi

ffmpeg -i "$file" -c:a aac -b:a 256k "m4a/$basename.m4a"
AtomicParsley "m4a/$basename.m4a" --lyricsFile "$basename.txt" --overWrite
echo "Conversion complete: $basename.m4a with embedded lyrics."
