#!/bin/bash

dependencies=("convert")

check_dependencies() {
    local missing=()
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo "Missing dependencies: ${missing[*]}"
        echo "Installing missing dependencies..."
        install_dependencies "${missing[@]}"
    fi
}

install_dependencies() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|linuxmint)
                sudo apt update
                sudo apt install -y imagemagick
                ;;
            centos|rhel|fedora)
                sudo yum install -y epel-release
                sudo yum install -y imagemagick
                ;;
            arch)
                sudo pacman -Syu --noconfirm imagemagick
                ;;
            *)
                echo "Unknown OS. Please install dependencies manually: ${missing[*]}"
                exit 1
                ;;
        esac
    else
        echo "Unable to detect OS. Please install dependencies manually: ${missing[*]}"
        exit 1
    fi
}

check_dependencies

if [ -z "$1" ]; then
    echo "Usage: ./convert_to_webp <folder> <quality>"
    echo "You must specify a folder and quality."
    echo "Quality must be a number between 0 (lowest) and 100 (highest)."
    exit 1
fi

if [ -z "$2" ]; then
    echo "Usage: ./convert_to_webp <folder> <quality>"
    echo "Quality must be a number between 0 (lowest) and 100 (highest)."
    exit 1
fi

folder=$1
quality=$2

if ! [[ "$quality" =~ ^[0-9]+$ ]] || [ "$quality" -lt 0 ] || [ "$quality" -gt 100 ]; then
    echo "Error: Quality must be a number between 0 and 100."
    exit 1
fi

if [ ! -d "$folder" ]; then
    echo "Error: Folder '$folder' not found."
    exit 1
fi

echo "Backing up $folder to $folder.bk..."
cp -r "$folder" "$folder.bk"

# Convert images in the folder to WebP format with the specified quality
find "$folder/" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | while IFS= read -r -d '' img; do
    # Set destination path inside the folder with the original structure
    dest="${img#$folder/}"
    dest_webp="$folder/${dest%.*}.webp"

    mkdir -p "$(dirname "$dest_webp")"

    if [ -f "$dest_webp" ]; then
        echo "Skipped: $dest_webp already exists"
        rm "$(realpath "$img")"
        echo "Deleted: $img"
        continue
    fi

    echo "Converting $img to $dest_webp with quality $quality"

    if convert "$img" -quality "$quality" "$dest_webp"; then
        rm "$(realpath "$img")"
        echo "Success: $dest_webp"
    else
        echo "Failed: $img"
    fi

done

echo "Compression and cleanup completed."
