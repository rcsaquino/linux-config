# My linux config

This repo contains my personal Linux configurations—dotfiles, scripts, wallpapers, and more.

## Setup dotfiles

1.  Clone this repository:
    ```bash
    git clone https://github.com/rcsaquino/linux-config ~/linux-config
    ```
2.  Navigate to the cloned directory:
    ```bash
    cd ~/linux-config
    ```
3.  Symlink dotfiles using the install script (e.g., for `zsh`, `zed`):
    ```bash
    ./install.sh link zsh
    ./install.sh link zed
    ```
4. Alternatively, use the dotf alias (available in the zsh dotfiles):
    ```bash
    dotf link zed
    ```
