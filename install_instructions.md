# Installation Instructions

System setup script and guide for restoring configurations.

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
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
paru
```

## Setup Linux Config
```bash
cd ~
git clone https://github.com/rcsaquino/linux-config.git
```

## Install Applications
```bash
paru -S zsh odin oh-my-zsh zoxide zed
```

## Setup and Link Dotfiles
```bash
mkdir ~/gitfiles
cd ~/gitfiles
git clone https://github.com/rcsaquino/dotf.git
cd dotf
odin build . -out:dotf -o:speed
mkdir -p ~/.local/bin
sudo ln -s ~/gitfiles/dotf/dotf /usr/local/bin/dotf
dotf link zsh zed
```
