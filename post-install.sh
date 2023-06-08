#!/bin/sh
set -ouex pipefail

# Install yafti via Pip
python3 -m pip install --prefix=/usr yafti

# Enable rpm-ostree automatic updates
cp /usr/share/ublue-os/update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf
systemctl enable rpm-ostreed-automatic.timer

# Enable the Flatpak auto-updater we inherit from uBlue
# (Allows us to remove GNOME Software)
systemctl enable flatpak-system-update.timer
systemctl --global enable flatpak-user-update.timer

# enable tty1
systemctl enable getty@tty1.service

#systemctl enable systemd-timesyncd.service
#systemctl enable systemd-resolved.service

# move OS systemd unit defaults to /usr
# (commented out because I'm not sure why upstream does this)
#cp -a --verbose /etc/systemd/system /etc/systemd/user /usr/lib/systemd/
#rm -r /etc/systemd/system /etc/systemd/user

# try to remove dmenu
#rpm-ostree override remove dmenu

# Configure Europe/London as our timezone
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime

# authselect enable-feature with-fingerprint
