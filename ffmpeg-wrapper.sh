#!/bin/sh

source="$1"
target="${source%.*}.flac"

echo "$source --> $target"
file "$source"
ffmpeg -i "$source" "$target"
