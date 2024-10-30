FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive
ENV GAME_INSTALL_DIR="/home/steam/Unturned"
ENV GAME_ID="1110390"
ENV SERVER_NAME="server"
ENV STEAM_USERNAME="anonymous"

EXPOSE 27015
EXPOSE 27016

# Add Steam user
RUN useradd -m -d /home/steam -s /bin/bash steam

# Create working directory
RUN mkdir -p /home/steam/Unturned && \
	cd /home/steam/Unturned && \
	chown -R steam /home/steam/Unturned

VOLUME ["/home/steam/Unturned"]

RUN mkdir -p /opt/steamcmd && \
    cd /opt/steamcmd && \
    chown -R steam /opt/steamcmd

WORKDIR /opt/steamcmd

COPY . .

# Set perms
RUN chmod +x init.sh && \
    chmod +x start_gameserver.sh

# Install required packages
RUN apt-get update && \
    apt-get install -y unzip tar curl coreutils lib32gcc1 libgdiplus && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER steam
WORKDIR /opt/steamcmd
ENTRYPOINT ["./init.sh"]
