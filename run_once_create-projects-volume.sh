#!/bin/sh

# get the container to create the volume with diskutil
container=$(diskutil apfs list | grep -m 1 -E 'Container disk[0-9]+' | grep -E 'disk[0-9]' | awk '{print $3}')

# Check if the volume already exists
if diskutil apfs list | grep -q /Volumes/Projects; then
    echo "Volume 'Projects' already exists. Skipping creation."
    exit 0
fi

# Add volume
diskutil apfs addVolume "$container" APFSX "Projects" -role D

# Verify creation
if [ $? -eq 0 ]; then
    echo "Volume 'Projects' created successfully."
else
    echo "Failed to create volume 'Projects'."
    exit 1
fi
