#!/bin/sh
# REMOVED: Previously was setting `set -eu` but I think it might
#          have been causing issues with the whole user session
#          quitting immediately on login if there was any error
#          in this script.
##set -eu

# Install our Yafti .desktop file if we're a non-root user who
# doesn't already have it installed.

if test "$(id -u)" -gt "0" && test -d "$HOME"; then
    if test ! -e "$HOME"/.config/autostart/goldenblue-firstboot.desktop; then
        mkdir -p "$HOME"/.config/autostart
        cp -f /etc/skel.d/.config/autostart/goldenblue-firstboot.desktop "$HOME"/.config/autostart/goldenblue-firstboot.desktop
    fi
fi
