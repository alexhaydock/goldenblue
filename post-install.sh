#!/bin/sh

set -ouex pipefail

pip install --prefix=/usr yafti

systemctl enable rpm-ostreed-automatic.timer
systemctl enable flatpak-system-update.timer

# enable tty1
systemctl enable getty@tty1.service

systemctl enable systemd-timesyncd.service
systemctl enable systemd-resolved.service

systemctl --global enable flatpak-user-update.timer

cp /usr/share/ublue-os/update-services/etc/rpm-ostreed.conf /etc/rpm-ostreed.conf

# move OS systemd unit defaults to /usr
cp -a --verbose /etc/systemd/system /etc/systemd/user /usr/lib/systemd/
rm -r /etc/systemd/system /etc/systemd/user

# try to remove dmenu
rpm-ostree override remove dmenu

ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

authselect enable-feature with-fingerprint

# DesktopEntry Execution: https://github.com/jceb/dex
curl -o /usr/bin/dex https://raw.githubusercontent.com/jceb/dex/942fe998db240357dc839e1df07b4fe6668a1c22/dex
chmod +x /usr/bin/dex