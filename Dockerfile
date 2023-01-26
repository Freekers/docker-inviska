# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-20.04-v4

# Install MKVToolnix
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends mkvtoolnix wget libglu1 libgtk2.0-0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download Inviska
RUN wget --no-check-certificate https://raw.githubusercontent.com/Freekers/docker-inviska/main/Inviska_MKV_Extract-11.0-x86_64.AppImage -P /opt/ && \
    chmod +x /opt/Inviska_MKV_Extract-11.0-x86_64.AppImage

# Copy the start script.
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Define mountable directories.
VOLUME ["/media"]

# Set the name of the application.
RUN set-cont-env APP_NAME "Inviska"