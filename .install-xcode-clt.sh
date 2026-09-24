#!/bin/sh

# exit if the command line tools are already installed
xcode-select -p > /dev/null 2>&1 && exit 0

# trigger the installer dialog and wait until it finishes
xcode-select --install
until xcode-select -p > /dev/null 2>&1; do
  sleep 5
done
