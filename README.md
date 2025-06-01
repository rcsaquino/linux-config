# My Linux Config

This repo contains my personal Linux configurations—dotfiles, scripts, wallpapers, and more.

Dotfiles are managed using [GNU Stow](https://www.gnu.org/software/stow/).

## Setup dotfiles

1.  Clone this repository:
    ```bash
    git clone https://github.com/rcsaquino/linux-config ~/linux-config
    ```
2.  Navigate to the cloned dotfiles directory:
    ```bash
    cd ~/linux-config/dotfiles
    ```
3.  Use Stow to symlink the desired configurations (e.g., for `zed`, `zsh`):
    ```bash
    # Add one at a time
    stow zed
    stow zsh
    ```
    ```bash
    # Add many at once
    stow zed zsh
    ```
