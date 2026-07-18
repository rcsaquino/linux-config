# Setup Guide

System setup guide for restoring configurations.

## Save Factory Packages
```bash
mkdir ~/factory_pkgs
cd ~/factory_pkgs
pacman -Qqe > factory_Qqe.txt
pacman -Qqet > factory_Qqet.txt
```

## Update System
```bash
sudo pacman -Syu
```

## Setup Paru (AUR Helper)
```bash
sudo pacman -S --needed base-devel git
sudo pacman -S rustup
rustup toolchain install stable
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
paru
```

## Install Applications
```bash
paru -S alacritty fzf nvm odin vim zed zoxide
```

## Setup NVIDIA
1. Install `paru -S nvidia-open nvidia-utils nvidia-settings` (Do this during archinstall if possible)
2. Edit `sudo vim /etc/mkinitcpio.conf`
3. Add `nvidia nvidia_modeset nvidia_uvm nvidia_drm` to `MODULES`
4. Delete `kms` from `HOOKS`
5. Run `sudo mkinitcpio -P`
6. Edit `sudo vim /etc/kernel/cmdline`
7. Add `nvidia_drm.modeset=1` and `nvidia_drm.fbdev=1` to the end of the line
8. Reboot

## Setup Niri + Noctalia
```bash
paru -S niri noctalia noctalia-greeter greetd dbus polkit gnome-keyring
```

## Setup ZSH
```bash
paru -S zsh oh-my-zsh-git zsh-autosuggestions-git zsh-completions-git zsh-syntax-highlighting
```

## Setup Dotfiles
```bash
cd ~
git clone https://github.com/rcsaquino/linux-config.git
mkdir gitfiles
cd gitfiles
git clone https://github.com/rcsaquino/dotf.git
cd dotf
odin build . -out:dotf -o:speed
sudo ln -s ~/gitfiles/dotf/dotf /usr/local/bin/dotf
dotf link alacritty niri noctalia paru zed zsh
```
