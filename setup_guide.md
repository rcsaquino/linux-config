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

## Setup Linux Config
```bash
cd ~
git clone https://github.com/rcsaquino/linux-config.git
```

## Setup Dotfiles
```bash
paru -S odin
mkdir ~/gitfiles
cd ~/gitfiles
git clone https://github.com/rcsaquino/dotf.git
cd dotf
odin build . -out:dotf -o:speed
sudo ln -s ~/gitfiles/dotf/dotf /usr/local/bin/dotf
dotf
```

## Setup ZSH
```bash
paru -S zsh oh-my-zsh-git zsh-autosuggestions-git zsh-completions-git zsh-syntax-highlighting
```

## Install Applications
```bash
paru -S alacritty zoxide zed
```
