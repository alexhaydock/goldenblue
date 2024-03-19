#!/bin/sh
# REMOVED: Previously was setting `set -eu` but I think it might
#          have been causing issues with the whole user session
#          quitting immediately on login if there was any error
#          in this script.
##set -eu

# Install our Powerline .bashrc.d snippet if we don't already
# have it present in our home directory

if test "$(id -u)" -gt "0" && test -d "$HOME"; then
    if test ! -e "$HOME"/.bashrc.d/powerline.sh; then
        mkdir -p "$HOME"/.bashrc.d
        cp -f /etc/skel.d/.bashrc.d/powerline.sh "$HOME"/.bashrc.d/powerline.sh
    fi
fi
