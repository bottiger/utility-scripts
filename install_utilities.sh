#!/bin/env bash
#
# Install common utilities on Debian/Ubuntu Linux and macOS.
# On mac the script will install homebrew if not already installed.
#

if ! sudo -n true 2>/dev/null; then
  echo "This script requires sudo privileges. Please enter your password."
  sudo -v || { echo "Unable to obtain sudo privileges. Exiting."; exit 1; }
fi

# Function to install a list of utilities
utilities=(
  "batcat"
  "curl"
  "wget"
  "git"
  "htop"
  "jq"
  "vim"
  "neovim"
  "tmux"
  "unzip"
  "net-tools" #linux only
  "starship" #brew only
)

install_on_linux() {
  echo "Updating package lists..."
  sudo apt-get update -y
  for utility in "${utilities[@]}"; do
    if ! command -v "$utility" > /dev/null; then
      echo "Installing $utility..."
      # Handle renaming (e.g., bat -> batcat on Ubuntu)
      if [[ "$utility" == "bat" ]]; then
        sudo apt-get install -y bat || sudo apt-get install -y batcat
      else
        sudo apt-get install -y "$utility"
      fi
    else
      echo "$utility is already installed. Skipping."
    fi
  done
}

install_on_mac() {
  echo "Checking Homebrew..."
  if ! command -v brew > /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  echo "Updating Homebrew..."
  brew update
  for utility in "${utilities[@]}"; do
    if ! brew list "$utility" &>/dev/null; then
      echo "Installing $utility..."
      brew install "$utility"

      echo >> /Users/bottiger/.bash_profile
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/bottiger/.bash_profile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      echo "$utility is already installed. Skipping."
    fi
  done
}

# Determine OS and call the appropriate function
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "installing on linux"
  install_on_linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "installing on mac"
  install_on_mac
else
  echo "Unsupported operating system: $OSTYPE"
  exit 1
fi

echo "All utilities are installed."