#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

backup() {
    local target=$1
    if [[ -e "$target" && ! -e "$backup_dir/${target#$HOME/}" ]]; then
        mkdir -p "$backup_dir/$(dirname "${target#$HOME/}")"
        cp -a "$target" "$backup_dir/${target#$HOME/}"
    fi
}

install_user_file() {
    local source=$1
    local target=$2
    backup "$target"
    install -Dm "${3:-644}" "$source" "$target"
}

install_user_file "$repo_dir/.bashrc" "$HOME/.bashrc"
install_user_file "$repo_dir/.config/i3/config" "$HOME/.config/i3/config"
install_user_file "$repo_dir/.config/polybar/config.ini" "$HOME/.config/polybar/config.ini"
install_user_file "$repo_dir/.config/polybar/launch.sh" "$HOME/.config/polybar/launch.sh" 755
install_user_file "$repo_dir/.config/picom/picom.conf" "$HOME/.config/picom/picom.conf"
install_user_file "$repo_dir/.config/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"
install_user_file "$repo_dir/.config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
install_user_file "$repo_dir/sddm/go/background.png" "$HOME/.local/share/backgrounds/go.png"

for script in "$repo_dir"/.local/bin/*; do
    install_user_file "$script" "$HOME/.local/bin/$(basename "$script")" 755
done

"$HOME/.local/bin/configure-polybar-hardware"

sudo install -Dm644 "$repo_dir/sddm/10-go-theme.conf" /etc/sddm.conf.d/10-go-theme.conf
sudo rm -rf /usr/share/sddm/themes/go
sudo install -d -m755 /usr/share/sddm/themes/go
sudo cp -a "$repo_dir/sddm/go/." /usr/share/sddm/themes/go/

printf 'Applied dotfiles. Existing user files are backed up in %s.\n' "$backup_dir"