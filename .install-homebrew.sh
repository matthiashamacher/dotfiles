#!/bin/sh

# exit if homebrew is already installed
type brew > /dev/null 2>&1 && exit

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
