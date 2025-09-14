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
    HOME=/app/steamcmd \
    XDG_RUNTIME_DIR=/tmp

RUN mkdir /app/steamcmd /app/sonsoftheforest /app/wine \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    gpg \
    lib32gcc-s1 \
    locales \
    procps \
    wget \
    winbind \
    x11-utils \
    # Set locale
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    # Install wine
    && mkdir -pm755 /etc/apt/keyrings \
    && wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key - \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources \
    && apt-get update \
    && apt-get install -y --install-recommends winehq-stable \
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

RUN wine64 wineboot --init

COPY --chown=steam:steam --chmod=550 main.sh /app/

ENTRYPOINT ["/app/main.sh"]
