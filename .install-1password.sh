#!/bin/sh

# exit if 1password is already installed
type op > /dev/null 2>&1 && exit

# install 1password
brew install 1password

# install 1password cli
brew install 1password-cli

source ~

# Login to 1password if not already logged in
if [ ! -f "${HOME}/.config/chezmoi/.1passwordlogin" ]; then
    op account add --address my.1password.eu
    eval $(op signin)
    op account list > "${HOME}/.config/chezmoi/.1passwordlogin"
fi
