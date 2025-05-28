# My Dotfiles

These are my personal configuration files, managed using [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

1.  Clone this repository:
    ```bash
    git clone https://github.com/rcsaquino/dotfiles.git ~/dotfiles
    ```
2.  Navigate to the cloned directory:
    ```bash
    cd ~/dotfiles
    ```
3.  Use Stow to symlink the desired configurations (e.g., for `nvim`, `zsh`):
    ```bash
    # Add one at a time
    stow nvim
    stow zsh
    # Add other packages as needed
    ```
    ```bash
    # Add many at once
    stow nvim zsh #other packages here
    ```
    ```bash
    # Add all at once
    stow *
    ```
