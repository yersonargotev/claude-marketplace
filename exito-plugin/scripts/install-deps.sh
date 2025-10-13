#!/bin/bash

# Function to check for a command and install it if not found
install_if_missing() {
    local command_name=$1
    local package_name=$2

    echo "Checking for '$command_name'..."
    if ! command -v "$command_name" &> /dev/null; then
        echo "'$command_name' not found. Attempting to install with Homebrew..."
        if ! command -v brew &> /dev/null; then
            echo "Error: Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        brew install "$package_name"
        if command -v "$command_name" &> /dev/null; then
            echo "'$package_name' installed successfully."
        else
            echo "Error: Failed to install '$package_name'. Please try installing it manually."
            exit 1
        fi
    else
        echo "'$command_name' is already installed."
    fi
}

# Install dependencies
install_if_missing "gh" "gh"
install_if_missing "az" "azure-cli"

echo "All required dependencies are set up."

# Ask user to log in if they haven't already
if ! gh auth status &> /dev/null; then
    echo "You are not logged into GitHub CLI. Please run 'gh auth login --web' to authenticate."
fi

if ! az account show &> /dev/null; then
    echo "You are not logged into Azure CLI. Please run 'az login --allow-no-subscriptions' to authenticate."
fi
