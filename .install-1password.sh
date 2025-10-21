#!/bin/sh

# exit if 1password is already installed
type op > /dev/null 2>&1 && exit

# install 1password
/opt/homebrew/bin/brew install 1password

open -n /Applications/1Password.app

# install 1password cli
/opt/homebrew/bin/brew install 1password-cli

# Login to 1password if not already logged in
if [ ! -f "${HOME}/.config/chezmoi/.1passwordlogin" ]; then
    op account add --address my.1password.eu
    eval $(op signin --cache --account my.1password.eu)
    op account list > "${HOME}/.config/chezmoi/.1passwordlogin"
fi
