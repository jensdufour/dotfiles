#!/usr/bin/env bash
set -euo pipefail

source_url=https://github.com/zsien-debian-repo/i3lock-color.git
source_commit=bea53f5547da1b44e9b627239bab10d9b95710b3
repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

sudo apt-get install -y --no-install-recommends \
    autoconf autoconf-archive automake build-essential git patch pkg-config \
    libcairo2-dev libev-dev libfontconfig1-dev libjpeg-dev libpam0g-dev \
    libxcb-composite0-dev libxcb-event1-dev libxcb-image0-dev libxcb-randr0-dev \
    libxcb-util0-dev libxcb-xinerama0-dev libxcb-xkb-dev libxcb-xrm0-dev \
    libxkbcommon-dev libxkbcommon-x11-dev

git clone --depth 1 --quiet "$source_url" "$work_dir/i3lock-color"
git -C "$work_dir/i3lock-color" checkout --quiet "$source_commit"
git -C "$work_dir/i3lock-color" apply "$repo_dir/patches/i3lock-color-progress.patch"

python3 - "$work_dir/i3lock-color" <<'PY'
from pathlib import Path
import sys

root = Path(sys.argv[1])
i3lock = root / "i3lock.c"
indicator = root / "unlock_indicator.c"

def replace_once(path, old, new):
    text = path.read_text()
    if text.count(old) != 1:
        raise SystemExit(f"expected one matching patch anchor in {path.name}")
    path.write_text(text.replace(old, new))

replace_once(i3lock, "int bar_width = 150;\n", "int bar_width = 150;\nint bar_total_width = 0;\n")
replace_once(i3lock,
    '        {"bar-width", required_argument, NULL, 702},\n',
    '        {"bar-width", required_argument, NULL, 702},\n        {"bar-total-width", required_argument, NULL, 706},\n')
replace_once(i3lock,
    '                // num_bars and bar_heights* initialized later when we grab display info\n                break;\n            case 703:',
    '                // num_bars and bar_heights* initialized later when we grab display info\n                break;\n            case 706:\n                bar_total_width = atoi(optarg);\n                if (bar_total_width < 1) bar_total_width = 0;\n                break;\n            case 703:')
replace_once(i3lock,
    '        int tmp = screen->width_in_pixels;\n        if (bar_orientation == BAR_VERT) tmp = screen->height_in_pixels;\n',
    '        int tmp = bar_total_width > 0 ? bar_total_width : screen->width_in_pixels;\n        if (bar_total_width == 0 && bar_orientation == BAR_VERT) tmp = screen->height_in_pixels;\n')
replace_once(indicator,
    '            x = i * bar_width;\n',
    '            x = (last_resolution[0] - (num_bars * bar_width)) / 2 + (i * bar_width);\n')
PY

cd "$work_dir/i3lock-color"
autoreconf -fi
./configure
make -j"$(nproc)"
sudo install -Dm755 i3lock /usr/local/bin/i3lock-color