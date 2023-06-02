ARG IMAGE_NAME="${IMAGE_NAME:-base}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-base}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ghcr.io/ublue-os/config:latest AS config
FROM ghcr.io/ublue-os/akmods:${FEDORA_MAJOR_VERSION} AS akmods

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

ADD build.sh /tmp/build.sh
ADD post-install.sh /tmp/post-install.sh
ADD packages.json /tmp/packages.json
COPY etc/ /etc/

COPY --from=config /rpms /tmp/rpms
COPY --from=akmods /rpms /tmp/akmods-rpms

RUN /tmp/build.sh
RUN /tmp/post-install.sh
RUN rm -rf /tmp/* /var/*
RUN ostree container commit
RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
