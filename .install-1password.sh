#!/bin/sh

# exit if 1password is already installed
type op > /dev/null 2>&1 && exit

# install 1password
brew install 1password

# install 1password cli
brew install 1password-cli
