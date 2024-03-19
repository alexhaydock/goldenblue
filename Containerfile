# We pass these vars in from the GitLab CI env vars using --build-arg
ARG FEDORA_MAJOR_VERSION
ARG IMAGE_NAME
ARG SOURCE_IMAGE

# Construct this var based on the above
ARG BASE_IMAGE="quay.io/fedora/fedora-${SOURCE_IMAGE}"

# Start our build operation
FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS goldenblue

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

COPY --chown=root:root --chmod=0700 augment-fedora-image.sh /tmp/augment-fedora-image.sh
COPY --chown=root:root --chmod=0600 packages.json /tmp/packages.json

# Add our layered etc/ and usr/ config from this repo
COPY --chown=root:root etc/ /etc/
COPY --chown=root:root usr/ /usr/

# Add some useful tools to the image that we pull from other Docker images
COPY --from=cgr.dev/chainguard/cosign:latest /usr/bin/cosign /usr/bin/cosign

# Configure Europe/London as our timezone
RUN ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime

# Run the build script from this repo, then commit the ostree
# image and do some cleanup tasks
#
# Some of this is Framework specific and could do with being updated
# to match more of what they're doing upstream where it's done in
# its own layer with its own json:
# https://github.com/ublue-os/framework/blob/main/framework-packages.json
RUN /tmp/augment-fedora-image.sh && \
    python3 -m pip install --prefix=/usr yafti && \
    systemctl enable tlp.service && \
    systemctl enable dconf-update.service && \
    systemctl enable flatpak-system-update.timer && \
    systemctl enable update-kargs.service && \
    systemctl --global enable flatpak-user-update.timer && \
    systemctl enable rpm-ostreed-automatic.timer && \
    rm -rf /tmp/* /var/* && \
    ostree container commit
