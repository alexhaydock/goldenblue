![Goldenblue Logo](logo.png)

# Goldenblue

Basically Fedora Silverblue, except my own golden image version of it... get it?

With thanks to [uBlue](https://ublue.it/) and [Seraphim Strub](https://dev.rievo.net/sst/uphy) for inspiring much of the work in this repo.

### Usage Instructions

1. Install [Fedora Silverblue](https://fedoraproject.org/silverblue/) from bootable ISO.
2. Rebase to Goldenblue:
```sh
sudo rpm-ostree rebase registry.gitlab.com/alexhaydock/goldenblue:38
```
3. Reboot

### Caveats
* This image is not currently built for `aarch64`. I'm aiming to fix this in future.
* I cannot offer any support for this image. You're on your own here if you try and use it.
