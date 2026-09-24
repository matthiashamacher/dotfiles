#!/bin/sh

[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Login to 1password if not already logged in
if ! op whoami >/dev/null 2>&1; then
    echo "Signing in to 1Password..."
    eval $(op signin --cache --account my.1password.eu)
fi
