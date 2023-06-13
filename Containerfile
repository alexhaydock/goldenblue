# We pass these vars in from the GitLab CI env vars using --build-arg
ARG FEDORA_MAJOR_VERSION
ARG IMAGE_NAME
ARG SOURCE_IMAGE

# Construct this var based on the above
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"

# Start our build operation
FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

COPY augment-fedora-image.sh /tmp/augment-fedora-image.sh
COPY packages.json /tmp/packages.json

# Add our layered etc/ and usr/ config from this repo
COPY etc/ /etc/
COPY usr/ /usr/

# Run the build script from this repo, then commit the ostree
# image and do some cleanup tasks
RUN chmod +x /tmp/augment-fedora-image.sh && \
    /tmp/augment-fedora-image.sh && \
    rm -rf /tmp/* /var/* && \
    ostree container commit && \
    mkdir -p /var/tmp && chmod -R 1777 /var/tmp
