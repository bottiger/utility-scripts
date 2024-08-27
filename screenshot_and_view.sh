#!/bin/env bash

# Script version
SCRIPT_VERSION="1.0"

# Default directory for saving the screenshot
DEFAULT_DIR="/tmp/screenshot_viewer"
DEST_DIR="$DEFAULT_DIR"

# Function to display help
show_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "This script takes a screenshot of the current window and displays it using gthumb."
    echo ""
    echo "Options:"
    echo "  --help           Show this help message and exit."
    echo "  --version        Show script version information and exit."
    echo "  --dir <path>     Specify the directory where the screenshot will be saved. Default is '$DEFAULT_DIR'."
    echo ""
    echo "Make sure both 'gthumb' and 'gnome-screenshot' are installed on your system."
}

# Function to display version
show_version() {
    echo "$(basename "$0") version $SCRIPT_VERSION"
}

# Parse arguments
while [[ "$1" != "" ]]; do
    case $1 in
        --help )           show_help
                           exit 0
                           ;;
        --version )        show_version
                           exit 0
                           ;;
        --dir )            shift
                           if [[ -d "$1" ]]; then
                               DEST_DIR="$1"
                           else
                               echo "Error: Directory '$1' does not exist."
                               exit 1
                           fi
                           ;;
        * )                echo "Unknown option: $1"
                           show_help
                           exit 1
    esac
    shift
done

FILENAME="$DEST_DIR/screenshot_$(date +%Y%m%d%H%M%S).png"

# Check if gthumb is installed
if ! command -v gthumb &> /dev/null
then
    echo "gthumb could not be found. Please install it using 'sudo apt-get install gthumb'."
    exit 1
fi

# Check if gnome-screenshot is installed
if ! command -v gnome-screenshot &> /dev/null
then
    echo "gnome-screenshot could not be found. Please install it using 'sudo apt-get install gnome-screenshot'."
    exit 1
fi

gnome-screenshot -w -f $FILENAME # -w for window


# Check if gthumb is already displaying the image
if pgrep -x "gthumb" > /dev/null
then
    # No need to kill gthumb; it will automatically refresh the displayed image
    :
else
    # Open the screenshot in gthumb if not already open
    gthumb $FILENAME &
fi
