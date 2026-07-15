# Dotfiles

Lean i3 desktop configuration for Ubuntu/X11 with a graphite and paper visual style.

## Includes

- i3, Polybar, Picom, Rofi, Alacritty, and Bash configuration
- Thunar on `Super+E`
- `i3lock-color` wrapper for `Super+L`
- Native Qt6 SDDM theme

## New Ubuntu Device

```bash
git clone https://github.com/your-account/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/bootstrap-ubuntu.sh
```

The bootstrap installs only the desktop components referenced by this configuration: i3, SDDM, Polybar, Picom, Rofi, Alacritty, Thunar, lock and notification tooling, NetworkManager/Bluetooth controls, audio controls, brightness control, and the required font. It does not install Edge, VS Code, Spotify, or any other application not used by this setup.

It builds the pinned custom `i3lock-color` binary under `/usr/local/bin`, installs the dotfiles, and detects the local battery/AC names for Polybar. It creates a timestamped backup of replaced user files under `~/.dotfiles-backup-*` and requires `sudo` for packages, the lock build, and SDDM.

## Existing Device

When dependencies and the custom lock are already present:

```bash
./install.sh
```

Run `./scripts/validate.sh` after installation. Select i3 from SDDM after signing out or rebooting.

## Privacy

This repository intentionally contains no hostnames, addresses, credentials, or account-specific paths. The login screen uses SDDM's active user model, and the included wallpaper is a neutral abstract image without an account label.