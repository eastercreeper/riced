# 🌸 Arch Hyprland Dotfiles

My personal **Arch Linux + Hyprland** configuration.

This repository contains my desktop configuration, launcher setup, terminal configuration, Fastfetch setup, and other files used for my Hyprland rice.

## 🖥️ Setup

* **OS:** Arch Linux
* **WM:** Hyprland
* **Shell:** Fish
* **Terminal:** Kitty
* **Bar / Widgets:** Eww
* **App Launcher:** Radiq
* **File Manager:** Yazi
* **System Info:** Fastfetch
* **Prompt:** Starship
* **Input Method:** Fcitx5

## 📁 Configs

```text
.config/
├── eww/          # Bar and desktop widgets
├── fastfetch/    # Fastfetch configuration and logo
├── fish/         # Fish shell configuration
├── hypr/         # Hyprland configuration
├── kitty/        # Kitty terminal
├── radiq/        # Radiq launcher
├── starship/     # Shell prompt
└── yazi/         # Terminal file manager
```

## ✨ Features

* Hyprland Wayland desktop
* Eww status bar
* Radiq radial application launcher
* Custom Fastfetch welcome screen
* Dynamic Fastfetch logo sizing based on terminal size
* Kitty terminal
* Fish shell
* Starship prompt
* Yazi terminal file manager
* Waypaper wallpaper management
* Hypridle
* Hyprlock
* Fcitx5 input support
* KDE Connect
* Bluetooth integration

## 🚀 Fastfetch

Fastfetch automatically runs when opening an interactive Fish shell.

The logo size changes depending on the terminal dimensions so that Fastfetch still displays correctly when Kitty is tiled into a smaller Hyprland window.

```fish
function fish_greeting
    set cols (tput cols)
    set lines (tput lines)

    if test $cols -lt 80 -o $lines -lt 24
        fastfetch --logo-height 8
    else if test $cols -lt 110 -o $lines -lt 32
        fastfetch --logo-height 12
    else
        fastfetch --logo-height 18
    end
end
```

## ⭕ Radiq

Radiq is used as the application launcher.

Some of my pinned applications include:

* Firefox
* Discord
* Sublime Text
* CLion
* Steam
* osu!
* KANNAGI USAGI

## 🎮 Gaming

The configuration also contains some game-specific tweaks, including an osu! launcher using CPU affinity and GameMode.

```bash
taskset -c 0-7 gamemoderun flatpak run sh.ppy.osu
```

## 🖼️ Screenshots

> Screenshots coming soon.

## 📦 Installation

Clone the repository:

```bash
git clone <repository-url>
cd <repository-name>
```

Back up your existing configuration before replacing anything:

```bash
cp -r ~/.config ~/.config.backup
```

Then copy the configs you want to use into `~/.config`.

**Do not blindly copy everything.** Some configuration files contain paths and settings specific to my system and may need to be changed for your setup.

## ⚠️ Notes

These dotfiles are primarily made for my own system.

Some paths, monitor settings, application names, scripts, wallpapers, and hardware-specific settings may need to be changed before they work correctly on another machine.

## ❤️ Credits

* Hyprland
* Arch Linux
* Eww
* Radiq
* Fastfetch
* Kitty
* Fish
* Starship
* Yazi

---

Made with 🌸 on Arch Linux.
