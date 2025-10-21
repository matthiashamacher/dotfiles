#!/bin/sh

# Login to 1password if not already logged in
if ! op whoami >/dev/null 2>&1; then
    echo "Signing in to 1Password..."
    eval $(op signin --cache --account my.1password.eu)
fi
