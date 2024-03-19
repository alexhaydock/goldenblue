#!/bin/sh
set -ouex pipefail

# Configure all directories in the etc/ dir tree
find etc/ -type d -exec chmod -c 0755 {} +

# Configure all files in the etc/ dir tree
find etc/ -type f -exec chmod -c 0644 {} +

# Configure all directories in the usr/ dir tree
find usr/ -type d -exec chmod -c 0755 {} +

# Configure all files in the usr/bin/ subdir tree
find usr/bin/ -type f -exec chmod -c 0755 {} +

# Configure all files in the usr/lib/ subdir tree
find usr/lib/ -type f -exec chmod -c 0644 {} +

# Configure shell scripts to be executable
find . -type f -iname '*.sh' -exec chmod -c 0755 {} +
