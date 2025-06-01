#!/bin/bash

# Configuration
DOTFILES_DIR="$HOME/linux-config/dotfiles"

show_usage() {
    echo "Commands:"
    echo " add <program> <path> - Move file/directory to dotfiles and create symlink"
    echo " link <program> - Create symlinks for program dotfiles"
    echo " unlink <program> - Remove symlinks for program dotfiles"  
    echo " delete <program> - Delete program dotfiles directory"
    echo " list - List available programs"
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
            read -p "Do you want to backup this file? (y/N): " -r < /dev/tty
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
    read -p "Continue? (y/N): " -r < /dev/tty
    [[ $REPLY =~ ^[Yy]$ ]] && unlink_dotfiles "$program" && rm -rf "$src_dir" && echo "Deleted: $src_dir"
}

list_programs() {
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        echo "No dotfiles directory found"
        return 1
    fi

    local linked_programs=()
    local unlinked_programs=()

    # Check each program's link status
    for program in "$DOTFILES_DIR"/*; do
        if [[ -d "$program" ]]; then
            local program_name="$(basename "$program")"
            local is_linked=true

            # Check if all files are properly linked
            while IFS= read -r -d '' file; do
                local rel_path="${file#$program/}"
                local target="$HOME/$rel_path"

                if [[ ! -L "$target" || "$(readlink "$target")" != "$file" ]]; then
                    is_linked=false
                    break
                fi
            done < <(find "$program" -type f -print0)

            # Add to appropriate list
            if $is_linked; then
                linked_programs+=("$program_name")
            else
                unlinked_programs+=("$program_name")
            fi
        fi
    done

    # Display linked programs
    echo "================"
    echo "=    Linked    ="
    echo "================"
    if [[ ${#linked_programs[@]} -eq 0 ]]; then
        echo "None"
    else
        printf "%s\n" "${linked_programs[@]}"
    fi

    echo

    # Display unlinked programs
    echo "================"
    echo "=   Unlinked   ="
    echo "================"
    if [[ ${#unlinked_programs[@]} -eq 0 ]]; then
        echo "None"
    else
        printf "%s\n" "${unlinked_programs[@]}"
    fi
}

add_dotfiles() {
    local program="$1"
    local source_path="$2"
    local cleanup_needed=false
    local dest_path=""
    local moved_file=false
    
    # Cleanup function
    cleanup_add() {
        local exit_code=$?
        if [[ $cleanup_needed == true && $exit_code -ne 0 ]]; then
            echo "Error occurred, rolling back changes..."
            
            # Remove symlink if created
            if [[ -L "$source_path" ]]; then
                rm "$source_path"
                echo "Removed symlink: $source_path"
            fi
            
            # Restore original file if moved
            if [[ $moved_file == true && -e "$dest_path" ]]; then
                mv "$dest_path" "$source_path"
                echo "Restored original file: $source_path"
            fi
            
            echo "Rollback complete"
        fi
        exit $exit_code
    }
    
    # Set trap for cleanup
    trap cleanup_add EXIT ERR
    
    # Validate inputs
    [[ -z "$program" ]] && { echo "Error: Program name required"; return 1; }
    [[ -z "$source_path" ]] && { echo "Error: Source path required"; return 1; }
    [[ ! -e "$source_path" ]] && { echo "Error: Source path does not exist: $source_path"; return 1; }
    
    # Check if source is a regular file (not directory)
    [[ ! -f "$source_path" ]] && { echo "Error: Source must be a regular file, not a directory: $source_path"; return 1; }
    
    # Convert to absolute path
    source_path="$(realpath "$source_path")" || { echo "Error: Cannot resolve path"; return 1; }
    
    # Create program directory if it doesn't exist
    local program_dir="$DOTFILES_DIR/$program"
    mkdir -p "$program_dir" || { echo "Error: Cannot create program directory"; return 1; }
    
    # Determine relative path from HOME
    local rel_path="${source_path#$HOME/}"
    [[ "$rel_path" == "$source_path" ]] && { echo "Error: Source path must be within HOME directory"; return 1; }
    
    # Destination in dotfiles directory
    dest_path="$program_dir/$rel_path"
    
    # Create destination directory structure
    mkdir -p "$(dirname "$dest_path")" || { echo "Error: Cannot create destination directory"; return 1; }
    
    # Check if file already exists in dotfiles
    if [[ -e "$dest_path" ]]; then
        echo "Error: File already exists in dotfiles: $dest_path"
        return 1
    fi
    
    # Enable cleanup from this point
    cleanup_needed=true
    
    # Move file to dotfiles
    mv "$source_path" "$dest_path" || { echo "Error: Failed to move file"; return 1; }
    moved_file=true
    echo "Moved: $source_path -> $dest_path"
    
    # Create symlink back to original location
    ln -s "$dest_path" "$source_path" || { echo "Error: Failed to create symlink"; return 1; }
    echo "Linked: $rel_path"
    
    # Success - disable cleanup rollback
    cleanup_needed=false
    trap - EXIT ERR
    
    echo "Successfully added $program dotfile: $rel_path"
}


# Main logic
case "$1" in
    link|unlink|delete)
        if [[ $# -lt 2 ]]; then
            echo "Error: At least one program name required."
            show_usage
            exit 1
        fi
        for program in "${@:2}"; do
            ${1}_dotfiles "$program"
        done
        ;;
    add)
        if [[ $# -ne 3 ]]; then
            echo "Error: Program name and source path required."
            echo "Usage: $0 add <program_name> <source_path>"
            exit 1
        fi
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

