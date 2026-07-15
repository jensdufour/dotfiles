#!/usr/bin/env bash
set -euo pipefail

command -v i3 polybar picom rofi alacritty thunar feh dunst xss-lock lxpolkit >/dev/null
test -x "$HOME/.local/bin/lock"
test -x /usr/local/bin/i3lock-color
i3 -C -c "$HOME/.config/i3/config"
fc-match 'Inconsolata Nerd Font Mono' | grep -q 'Inconsolata Nerd Font Mono'
printf 'Dotfiles validation passed.\n'