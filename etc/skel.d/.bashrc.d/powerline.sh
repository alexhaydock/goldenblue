#!/bin/sh

# See: https://fedoramagazine.org/add-power-terminal-powerline/

# Tweaked so this doesn't throw errors inside a Distrobox or
# Toolbx container that doesn't have Powerline installed
if [ "$(which powerline-daemon 2>/dev/null)" ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  # Fedora
  if [ -f "/usr/share/powerline/bash/powerline.sh" ]; then
    . /usr/share/powerline/bash/powerline.sh
  # Debian/Ubuntu
  elif [ -f "/usr/share/powerline/bindings/shell/powerline.sh" ]; then
    . /usr/share/powerline/bindings/shell/powerline.sh
  fi
fi
