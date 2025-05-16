## Copyright 2018-present Network Optix, Inc. Licensed under MPL 2.0: www.mozilla.org/MPL/2.0/

ARG BASE_IMAGE=ubuntu:22.04
FROM $BASE_IMAGE
LABEL maintainer="Network Optix <support@networkoptix.com>"

# VMS Server debian package file or URL.
ARG MEDIASERVER_DEB=https://updates.networkoptix.com/metavms/39873/linux/metavms-server-6.0.1.39873-linux_x64.deb

# VMS Server user and directory name.
ARG COMPANY="networkoptix-metavms"
# Also export as environment variable to use at entrypoint.
ENV COMPANY=${COMPANY}

# Disable EULA dialogs and confirmation prompts in installers.
ENV DEBIAN_FRONTEND=noninteractive

# Install packages.
RUN apt-get update && \
    apt-get install -y \
        apt-utils \
        binutils \
        curl \
        jq && \
    curl -O "${MEDIASERVER_DEB}" && \
    apt-get install -y ./"${MEDIASERVER_DEB##*/}" && \
    chattr -i /lib/systemd/systemd-coredump && \
    rm "${MEDIASERVER_DEB##*/}" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Fix permissions.
RUN chown ${COMPANY}: /opt/${COMPANY}/mediaserver/var/

RUN echo "currentOsVariantOverride=docker" >> /opt/${COMPANY}/mediaserver/etc/mediaserver.conf

ADD entrypoint.sh /opt/mediaserver/

USER ${COMPANY}
WORKDIR /home/${COMPANY}

# Runs the media server on container start unless argument(s) specified.
ENTRYPOINT ["/opt/mediaserver/entrypoint.sh"]
