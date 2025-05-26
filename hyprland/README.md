# **`ianisbored's` Dotfiles**

My config files for hyprland and other utilities with some shell scripts. **Heavily customised for my workflow and only meant to be a reference**



## Screenshots
![[4.png]]
![[hyprland/screenshots/1.png]]
![[2.png]]
![[3.png]]

## Packages

### Official Repo
Needed
```
ttf-jetbrains-mono ttf-jetbrains-mono-nerd hyprpicker hyprpaper neovim hyprpolkitagent nwg-look scrcpy nemo rofi-wayland copyq flatpak fastfetch imagemagick
```

My preferred extras
```
vlc loupe gnome-boxes nemo-fileroller apple-fonts ttf-apple-emoji gnome-characters
```

### AUR
```
gruvbox-dark-icons-gtk gruvbox-material-gtk-theme-git hyprshot zen-browser-bin
```
## Installation

- Clone this repo at `.config/` in your home directory

```bash
git clone https://github.com/ianisbored/dotfiles
```

- Edit `~/.config/hypr/hyprland.conf` to only include `source = ~/.config/dotfiles/hyprland/hyprland.conf`
```bash
echo 'source = ~/.config/dotfiles/hyprland/hyprland.conf' > ~/.config/hypr/hyprland.conf
```

- Reboot

## Extras

- [NvChad](https://nvchad.com/) a preconfigured neovim setup
- [Zsh config](https://github.com/pixegami/terminal-profile) for this setup, **edit the scripts according to your package manager first**