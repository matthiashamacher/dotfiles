#!/bin/sh

# exit if homebrew is already installed
type brew > /dev/null 2>&1 && exit

# cache sudo credentials so the installer can run without the "Press RETURN" prompt
sudo -v

# install homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/opt/homebrew/bin/brew shellenv)"

# install zerobrew
curl -fsSL https://zerobrew.rs/install | bash

export