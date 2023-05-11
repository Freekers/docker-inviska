# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-20.04-v4

# Install Dependencies
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends apt-transport-https ca-certificates wget libglu1 libgtk2.0-0

# Install latest MKVToolnix
# https://mkvtoolnix.download/downloads.html#ubuntu
RUN wget -O /usr/share/keyrings/gpg-pub-moritzbunkus.gpg https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg && \
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/gpg-pub-moritzbunkus.gpg] https://mkvtoolnix.download/ubuntu/ $(. /etc/os-release && echo $VERSION_CODENAME) main" >> /etc/apt/sources.list.d/mkvtoolnix.list' && \
    apt-get update && \
    apt-get -y install --no-install-recommends mkvtoolnix=74.0.0-0~ubuntu2004bunkus01 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download Inviska
RUN wget https://raw.githubusercontent.com/Freekers/docker-inviska/main/Inviska_MKV_Extract-11.0-x86_64.AppImage -P /opt/ && \
    chmod +x /opt/Inviska_MKV_Extract-11.0-x86_64.AppImage

# Copy the start script.
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Define mountable directories.
VOLUME ["/media"]

# Set the name of the application.
RUN set-cont-env APP_NAME "Inviska"
