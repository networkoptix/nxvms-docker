## Copyright 2018-present Network Optix, Inc. Licensed under MPL 2.0: www.mozilla.org/MPL/2.0/

ARG BASE_IMAGE=harbor.nxvms.dev/nxvms/metavms-server

FROM $BASE_IMAGE

ENV PLUGIN_DIR=/opt/networkoptix-metavms/mediaserver/bin/plugins/nxai_plugin
ENV VER=v4-1

# Swithch user to make changes
USER root

RUN mkdir -p ${PLUGIN_DIR} && \
    curl https://artifactory.nxvms.dev/artifactory/nxai_open/NXAIPlugin/${VER}/libnxai_plugin.so \
      -o ${PLUGIN_DIR}/libnxai_plugin.so && \
    chmod +x -R ${PLUGIN_DIR}

# Switch to application user
USER ${COMPANY}
