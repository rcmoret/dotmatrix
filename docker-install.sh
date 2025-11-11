#!/usr/bin/env bash

# colors

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
normal=$(tput sgr0)

# Print functions

print_padded() {
  len=${#2}
  printf "%-50s [$3%$((len+(10-len)/2))s%$(((10-len)/2))s$normal]\n" "$1" "$2"
}

create_notice() {
  print_padded "Creating $1" "$2" $green
}

skip_notice() {
  print_padded "${yellow}Skipping${normal} $1" "$2" $yellow
}

copy_notice() {
  print_padded "${green}Copying${normal}  $1" "$2" $green
}

link_notice() {
  print_padded "${green}Linking${normal}  $1" "$2" $green
}

remove_notice() {
  print_padded "${red}Removing${normal} $1" "$2" $red
}

# Determine HOME directory (important in Docker)
# if [ -z "$HOME" ]; then
#     HOME=$(eval echo ~$(whoami))
# fi

# echo "Installing .bashrc to: $HOME/.bashrc"

# # Check if curl is available
# if ! command -v curl &> /dev/null; then
#     echo "${red}ERROR: curl is not installed${normal}"
#     echo "Please install curl first: apt-get update && apt-get install -y curl"
#     exit 1
# fi

# # Ensure HOME directory exists
# if [ ! -d "$HOME" ]; then
#     echo "${yellow}WARNING: HOME directory $HOME does not exist, creating it...${normal}"
#     mkdir -p "$HOME"
# fi

# DOTFILES_BRANCH=dotmatrix-version

# Download .bashrc with error handling
echo "Downloading .bashrc from GitHub..."
BASHRC_URL="https://raw.githubusercontent.com/rcmoret/dotmatrix/refs/heads/docker-version/.bashrc"

curl -fsSL "$BASHRC_URL" > "/.bashrc"
