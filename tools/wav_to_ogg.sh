#!/bin/bash

DIR="tts/ja"

echo "Converting WAVs to OGG..."

for f in "$DIR"/*.wav; do
    [ -f "$f" ] || continue
    ffmpeg -y -i "$f" -c:a libvorbis -b:a 32k "${f%.wav}.ogg" && rm "$f"
done

echo "Done"