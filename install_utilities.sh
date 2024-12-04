#!/bin/env bash

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
  "net-tools"
)

# Update package lists
echo "Updating package lists..."
sudo apt-get update -y
# Iterate through the list and install missing utilities
for utility in "${utilities[@]}"; do
  if ! command -v "$utility" > /dev/null; then
    echo "Installing $utility..."
    sudo apt-get install -y "$utility"
  else
    echo "$utility is already installed. Skipping."
  fi
done
echo "All utilities are installed."
