ARG IMAGE_NAME="${IMAGE_NAME:-base}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-base}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

# Import the uBlue config container to provide config (https://github.com/ublue-os/config)
FROM ghcr.io/ublue-os/config:latest AS config

# Start our build operation
FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

COPY build.sh /tmp/build.sh
COPY post-install.sh /tmp/post-install.sh
COPY packages.json /tmp/packages.json

# Add our layered etc/ config from this repo
COPY etc/ /etc/

# Import the built rpms from the uBlue config container
# these are built here:
#   https://github.com/ublue-os/config/blob/main/Containerfile
# and mostly contain some udev rules for common devices as well as
# some useful Flatpak auto-update services.
COPY --from=config /rpms /tmp/rpms

# Run the build scripts from this repo, then commit the ostree
# image and do some cleanup tasks
RUN /tmp/build.sh && \
    /tmp/post-install.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp
