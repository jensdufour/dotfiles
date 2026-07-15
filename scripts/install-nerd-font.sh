#!/usr/bin/env bash
set -euo pipefail

font_version=3.4.0
font_dir="$HOME/.local/share/fonts/InconsolataNerdFont"
archive=$(mktemp)
trap 'rm -f "$archive"' EXIT

mkdir -p "$font_dir"
curl --fail --location --retry 3 \
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v${font_version}/Inconsolata.zip" \
    --output "$archive"
unzip -oq "$archive" -d "$font_dir"
fc-cache -f "$font_dir"