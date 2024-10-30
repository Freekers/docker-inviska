# Pull base image
FROM jlesage/baseimage-gui:ubuntu-22.04-v4

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    MKVTOOLNIX_VERSION=73.0.0-0~ubuntu2204bunkus01 \
    INVISKA_VERSION=11.0

# MKVToolnix 73 is the last version compatible with Inviska. MKVToolnix 74 or newer will not work!
# hadolint ignore=DL3008
RUN set -eux \
    # First install wget and other basic dependencies
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        wget \
    # Now add MKVToolnix repository
    && wget -qO /usr/share/keyrings/gpg-pub-moritzbunkus.gpg https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/ubuntu/ jammy main" > /etc/apt/sources.list.d/mkvtoolnix.list \
    && echo "deb-src [arch=amd64 signed-by=/usr/share/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/ubuntu/ jammy main" >> /etc/apt/sources.list.d/mkvtoolnix.list \
    # Update again with new repository and install remaining packages
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libglu1 \
        libgtk2.0-0 \
        mkvtoolnix=${MKVTOOLNIX_VERSION} \
    # Download Inviska
    && wget -q https://raw.githubusercontent.com/Freekers/docker-inviska/main/Inviska_MKV_Extract-${INVISKA_VERSION}-x86_64.AppImage -P /opt/ \
    && chmod +x /opt/Inviska_MKV_Extract-${INVISKA_VERSION}-x86_64.AppImage \
    # Cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# Copy and prepare the start script
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Define mountable directories
VOLUME ["/media"]

# Set the application name
RUN set-cont-env APP_NAME "Inviska"

# Add labels for better maintainability
LABEL maintainer="Freekers" \
      version="1.0" \
      description="Inviska MKV Extract Docker Image" \
      org.opencontainers.image.source="https://github.com/Freekers/docker-inviska"
