#!/bin/sh
set -eu

# Install our Yafti .desktop file if we're a non-root user who
# doesn't already have it installed.

if test "$(id -u)" -gt "0" && test -d "$HOME"; then
    if test ! -e "$HOME"/.config/autostart/bluefin-firstboot.desktop; then
        mkdir -p "$HOME"/.config/autostart
        cp -f /etc/skel.d/.config/autostart/firstboot.desktop "$HOME"/.config/autostart
    fi
fi
