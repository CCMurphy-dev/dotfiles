# dotfiles

Config files for my macOS window management setup.

## What's in here

- **yabai/** — [Tiling window manager](https://github.com/koekeishiya/yabai) using BSP layout. Handles per-app space assignments, float/stack rules (e.g. SPSS windows auto-stack by type), and an ultrawide monitor script (`scripts/yabaiUW.sh`) that adjusts padding dynamically based on window count.
- **skhd/** — [Hotkey daemon](https://github.com/koekeishiya/skhd) for yabai keybindings. Uses hyper key (Caps Lock) for window warping, space focus, float toggles, layout rotation, and padding presets.
- **aegis/** — Custom menu bar and notch HUD app. Config controls app switcher, media HUD, notification HUD, space indicators with app icons, and visual theming. Includes a yabai notify script for real-time window event integration.

## Setup

Configs are symlinked to `~/.config/`:

```sh
ln -s ~/Dev/dotfiles/yabai ~/.config/yabai
ln -s ~/Dev/dotfiles/skhd ~/.config/skhd
ln -s ~/Dev/dotfiles/aegis ~/.config/aegis
```
