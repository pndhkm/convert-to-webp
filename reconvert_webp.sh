#!/bin/bash

dependencies=("cwebp")

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
                sudo apt install -y webp
                ;;
            centos|rhel|fedora)
                sudo yum install -y epel-release
                sudo yum install -y libwebp-tools
                ;;
            arch)
                sudo pacman -Syu --noconfirm libwebp
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
    echo "Usage: ./reconvert_webp.sh.sh <folder> <quality>"
    echo "You must specify a folder and quality."
    echo "Quality must be a number between 1 (lowest) and 100 (highest)."
    exit 1
fi

if [ -z "$2" ]; then
    echo "Usage: ./reconvert_webp.sh.sh <folder> <quality>"
    echo "Quality must be a number between 1 (lowest) and 100 (highest)."
    exit 1
fi

input_folder=$1
quality=$2

if ! [[ "$quality" =~ ^[0-9]+$ ]] || [ "$quality" -lt 0 ] || [ "$quality" -gt 100 ]; then
    echo "Error: Quality must be a number between 0 and 100."
    exit 1
fi

if [ ! -d "$input_folder" ]; then
    echo "Error: Folder '$input_folder' not found."
    exit 1
fi

find "$input_folder" -type f -iname "*.webp" -print0 | while IFS= read -r -d '' img; do
    temp_file="${img%.*}_temp.webp"

    echo "Reconverting $img with quality $quality"

    # Reconvert WebP file with the new quality
    if cwebp -q "$quality" "$img" -o "$temp_file"; then
        mv "$temp_file" "$img"
        echo "Success: $img Reconverted"
    else
        echo "Failed: $img"
        rm -f "$temp_file"
    fi
done

echo "Reconvertion completed."
