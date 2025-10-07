#!/bin/sh

# get the container to create the volume with diskutil
container=$(diskutil apfs list | grep -m 1 -E 'Container disk[0-9]+' | grep -E 'disk[0-9]' | awk '{print $3}')

# Add volume
diskutil apfs addVolume "$container" APFSX "Projects" -role D
