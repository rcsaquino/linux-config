#!/bin/bash

# Configuration
DOTFILES_DIR="$HOME/linux-config/dotfiles"

show_usage() {
    echo "Commands:"
    echo "  link <program>    - Create symlinks for program dotfiles"
    echo "  unlink <program>  - Remove symlinks for program dotfiles"
    echo "  delete <program>  - Delete program dotfiles directory"
    echo "  list              - List available programs"
}

link_dotfiles() {
    local program="$1"
    local src_dir="$DOTFILES_DIR/$program"

    [[ ! -d "$src_dir" ]] && { echo "Error: $src_dir does not exist"; return 1; }

    find "$src_dir" -type f | while read -r file; do
        local rel_path="${file#$src_dir/}"
        local target="$HOME/$rel_path"

        mkdir -p "$(dirname "$target")"

        if [[ -e "$target" && ! -L "$target" ]]; then
            echo "File exists: $target"
            read -p "Do you want to backup this file? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mv "$target" "$target.backup"
                echo "Backed up: $target -> $target.backup"
            else
                echo "Overwriting: $target"
            fi
        fi

        ln -sf "$file" "$target"
        echo "Linked: $rel_path"
    done
}

unlink_dotfiles() {
    local program="$1"
    local src_dir="$DOTFILES_DIR/$program"

    [[ ! -d "$src_dir" ]] && { echo "Error: $src_dir does not exist"; return 1; }

    find "$src_dir" -type f | while read -r file; do
        local rel_path="${file#$src_dir/}"
        local target="$HOME/$rel_path"

        if [[ -L "$target" && "$(readlink "$target")" == "$file" ]]; then
            rm "$target"
            echo "Unlinked: $rel_path"
        fi
    done
}

# Function to delete dotfiles
delete_dotfiles() {
    local program="$1"
    local src_dir="$DOTFILES_DIR/$program"

    [[ ! -d "$src_dir" ]] && { echo "Error: $src_dir does not exist"; return 1; }

    echo "Warning: This will delete $src_dir"
    read -p "Continue? (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] && unlink_dotfiles "$program" && rm -rf "$src_dir" && echo "Deleted: $src_dir"
}

# Function to list programs
list_programs() {
    [[ -d "$DOTFILES_DIR" ]] && ls -1 "$DOTFILES_DIR" || echo "No dotfiles directory found"
}

# Main logic
case "$1" in
    link|unlink|delete)
        [[ -z "$2" ]] && { echo "Error: Program name required"; usage; exit 1; }
        ${1}_dotfiles "$2"
        ;;
    list)
        list_programs
        ;;
    *)
        show_usage
        exit 1
        ;;
esac
