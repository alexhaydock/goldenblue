#!/bin/sh
set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# Parse our packages.json into shell vars
INCLUDED_PACKAGES=($(jq -r "[(.all.include | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".include | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
                             | sort | unique[]" /tmp/packages.json))
EXCLUDED_PACKAGES=($(jq -r "[(.all.exclude | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".exclude | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
                             | sort | unique[]" /tmp/packages.json))

# Iterate through the undesirable packages and make sure we actually have them, rather
# than trying to remove packages we don't actually have installed in the base image
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    EXCLUDED_PACKAGES=($(rpm -qa --queryformat='%{NAME} ' ${EXCLUDED_PACKAGES[@]}))
fi

# Install our desired packages and remove the ones we don't want
if [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 && "${#EXCLUDED_PACKAGES[@]}" -eq 0 ]]; then
    rpm-ostree install \
        ${INCLUDED_PACKAGES[@]}

elif [[ "${#INCLUDED_PACKAGES[@]}" -eq 0 && "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${EXCLUDED_PACKAGES[@]}

elif [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 && "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${EXCLUDED_PACKAGES[@]} \
        $(printf -- "--install=%s " ${INCLUDED_PACKAGES[@]})
else
    echo "No packages to install."
fi

# Install Yafti via Pip to handle Flatpak postinstall once we get
# to a desktop
python3 -m pip install --prefix=/usr yafti

# Enable rpm-ostree automatic updates
systemctl enable rpm-ostreed-automatic.timer

# Enable the Flatpak auto-updater we inherit from uBlue
# (Allows us to remove GNOME Software)
systemctl enable flatpak-system-update.timer
systemctl --global enable flatpak-user-update.timer

# enable tty1
systemctl enable getty@tty1.service

# Configure Europe/London as our timezone
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
