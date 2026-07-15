# Dotfiles

Lean i3 desktop configuration for Ubuntu/X11 with a graphite and paper visual style.

## Includes

- i3, Polybar, Picom, Rofi, Alacritty, and Bash configuration
- Thunar on `Super+E`
- `i3lock-color` wrapper for `Super+L`
- Native Qt6 SDDM theme

## Requirements

Install the corresponding desktop packages before applying this repository. The lock wrapper expects `i3lock-color` at `/usr/local/bin/i3lock-color`; build or install that binary separately.

## Install

```bash
git clone https://github.com/your-account/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The installer creates a timestamped backup of replaced user files under `~/.dotfiles-backup-*`. It requires `sudo` only for the SDDM theme and theme selection file.

## Privacy

This repository intentionally contains no hostnames, addresses, credentials, or account-specific paths. The login screen uses SDDM's active user model, and the included lock background is a neutral wallpaper without an account label.