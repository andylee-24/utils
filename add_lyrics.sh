#!/bin/zsh
set -euo pipefail

file=$(print -rl -- *.mp3(N) | fzf --prompt="Select an MP3 file: ")
if [[ -z "${file:-}" ]]; then
  echo "No file selected. Exiting."
  exit 1
fi

basename="${file%.mp3}"

ffmpeg -i "$file" -c:a aac -b:a 256k "$basename.m4a"
AtomicParsley "$basename.m4a" --lyricsFile lyrics.txt --overWrite
