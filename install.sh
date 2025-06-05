#!/bin/bash

# Configuration
DOTFILES_DIR="$HOME/linux-config/dotfiles"

# Utility functions
error_exit() { echo "Error: $1" >&2; exit 1; }
program_dir() { echo "$DOTFILES_DIR/$1"; }
check_program_exists() { [[ -d "$(program_dir "$1")" ]] || error_exit "$1 does not exist"; }

show_usage() {
    cat << EOF
Commands:
 add <program> <file_path>     - Move file to dotfiles and create symlink
 link <program>...             - Create symlinks for program dotfiles
 unlink <program>...           - Remove symlinks for program dotfiles  
 delete <program>...           - Delete program dotfiles directory
 list                          - List available programs
EOF
}

link_dotfiles() {
    local program="$1"
    check_program_exists "$program"
    
    while IFS= read -r -d '' file; do
        local rel_path="${file#$(program_dir "$program")/}"
        local target="$HOME/$rel_path"
        
        mkdir -p "$(dirname "$target")"
        
        if [[ -e "$target" && ! -L "$target" ]]; then
            read -p "File exists: $target. Backup? (y/N): " -r < /dev/tty
            [[ $REPLY =~ ^[Yy]$ ]] && mv "$target" "$target.backup"
        fi
        
        ln -sf "$file" "$target"
        echo "Linked: $rel_path"
    done < <(find "$(program_dir "$program")" -type f -print0)
}

unlink_dotfiles() {
    local program="$1"
    check_program_exists "$program"
    
    while IFS= read -r -d '' file; do
        local rel_path="${file#$(program_dir "$program")/}"
        local target="$HOME/$rel_path"
        
        if [[ -L "$target" && "$(readlink "$target")" == "$file" ]]; then
            rm "$target"
            echo "Unlinked: $rel_path"
        fi
    done < <(find "$(program_dir "$program")" -type f -print0)
}

delete_dotfiles() {
    local program="$1"
    check_program_exists "$program"
    
    read -p "Delete $(program_dir "$program")? (y/N): " -r < /dev/tty
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        unlink_dotfiles "$program"
        rm -rf "$(program_dir "$program")"
        echo "Deleted: $program"
    fi
}

is_program_linked() {
    local program_path="$1"
    while IFS= read -r -d '' file; do
        local rel_path="${file#$program_path/}"
        local target="$HOME/$rel_path"
        [[ -L "$target" && "$(readlink "$target")" == "$file" ]] || return 1
    done < <(find "$program_path" -type f -print0)
    return 0
}

list_programs() {
    [[ ! -d "$DOTFILES_DIR" ]] && { echo "No dotfiles directory found"; return 1; }
    
    local linked=() unlinked=()
    
    for program_path in "$DOTFILES_DIR"/*; do
        [[ -d "$program_path" ]] || continue
        local name="$(basename "$program_path")"
        
        if is_program_linked "$program_path"; then
            linked+=("$name")
        else
            unlinked+=("$name")
        fi
    done
    
    # Display linked programs
    echo "================"
    echo "=    Linked    ="
    echo "================"
    if [[ ${#linked[@]} -eq 0 ]]; then
        echo "None"
    else
        printf "%s\n" "${linked[@]}"
    fi
    echo

    # Display unlinked programs
    echo "================"
    echo "=   Unlinked   ="
    echo "================"
    if [[ ${#unlinked[@]} -eq 0 ]]; then
        echo "None"
    else
        printf "%s\n" "${unlinked[@]}"
    fi
    echo
}

add_dotfiles() {
    local program="$1" source_path="$2"
    
    # Validation
    [[ -n "$program" && -n "$source_path" ]] || error_exit "Program name and source path required"
    [[ -f "$source_path" ]] || error_exit "Source must be a regular file: $source_path"
    
    source_path="$(realpath "$source_path")" || error_exit "Cannot resolve path"
    local rel_path="${source_path#$HOME/}"
    [[ "$rel_path" != "$source_path" ]] || error_exit "Source path must be within HOME directory"
    
    local dest_path="$(program_dir "$program")/$rel_path"
    [[ ! -e "$dest_path" ]] || error_exit "File already exists in dotfiles: $dest_path"
    
    # Execute with simple rollback on failure
    mkdir -p "$(dirname "$dest_path")" || error_exit "Cannot create destination directory"
    
    if mv "$source_path" "$dest_path" && ln -s "$dest_path" "$source_path"; then
        echo "Added $program dotfile: $rel_path"
    else
        # Rollback on failure
        [[ -e "$dest_path" ]] && mv "$dest_path" "$source_path" 2>/dev/null
        [[ -L "$source_path" ]] && rm "$source_path" 2>/dev/null
        error_exit "Failed to add dotfile"
    fi
}

# Main execution
case "$1" in
    link|unlink|delete)
        [[ $# -ge 2 ]] || error_exit "At least one program name required"
        for program in "${@:2}"; do
            ${1}_dotfiles "$program"
        done
        ;;
    add)
        [[ $# -eq 3 ]] || error_exit "Usage: add <program> <file_path>"
        add_dotfiles "$2" "$3"
        ;;
    list)
        list_programs
        ;;
    *)
        show_usage
        exit 1
        ;;
esac
