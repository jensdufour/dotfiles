#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    alacritty blueman brightnessctl ca-certificates curl dbus-x11 dunst feh \
    fonts-inconsolata i3-wm libnotify-bin lxpolkit network-manager network-manager-gnome \
    pavucontrol picom polybar rofi sddm thunar unzip x11-xserver-utils xss-lock

"$repo_dir/scripts/install-nerd-font.sh"
"$repo_dir/scripts/build-i3lock-color.sh"
"$repo_dir/install.sh"
"$repo_dir/scripts/validate.sh"