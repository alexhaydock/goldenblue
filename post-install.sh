#!/bin/sh

set -ouex pipefail

systemctl enable rpm-ostreed-automatic.timer
systemctl enable flatpak-system-update.timer

# set up PAM for systemd-homed
authselect enable-feature with-systemd-homed

# enable tty1
systemctl enable getty@tty1.service

systemctl enable systemd-timesyncd.service
systemctl enable systemd-resolved.service
systemctl enable systemd-homed.service

systemctl --global enable flatpak-user-update.timer

cp /usr/share/ublue-os/update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf

# move OS systemd unit defaults to /usr
cp -a --verbose /etc/systemd/system /etc/systemd/user /usr/lib/systemd/
rm -r /etc/systemd/system /etc/systemd/user