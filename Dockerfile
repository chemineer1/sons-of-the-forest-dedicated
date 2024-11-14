FROM debian:bookworm-slim

EXPOSE 8766/udp 27016/udp 9700/udp

USER root
WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    WINEPREFIX=/app/wine \
    WINEARCH=win64 \
    WINEDEBUG=-all \
    DISPLAY=:1.0 \
    HOME=/app/steamcmd

RUN mkdir /app/steamcmd /app/sonsoftheforest /app/wine \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    lib32gcc-s1 \
    locales \
    nano \
    procps \
    wget \
    winbind \
    xserver-xorg-core \
    xserver-xorg-video-dummy \
    xinit \
    # Set locale
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    # Install wine
    && dpkg --add-architecture i386 \
    && mkdir -pm755 /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources \
    && apt-get update \
    && apt-get install -y --no-install-recommends winehq-stable \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    # Create steam user
    && useradd --no-create-home --shell /usr/sbin/nologin steam \
    # Change ownership
    && chown -R steam:steam /app \
    # Change permissions
    && chmod -R 750 /app

# Switch to steam user
USER steam

# Download steamcmd
RUN ["/bin/bash", "-c", "set -o pipefail && wget -qO- https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -v -C /app/steamcmd -zx"]

# Download Sons of the Forest dedicated server
RUN /app/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /app/sonsoftheforest +login anonymous +app_update 2465200 validate +quit

COPY xorg.conf /etc/X11/xorg.conf
COPY --chown=steam:steam --chmod=550 main.sh /app/

CMD ["/bin/bash", "-c", "/app/main.sh"]
