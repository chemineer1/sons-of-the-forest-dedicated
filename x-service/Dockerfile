FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    xserver-xorg-video-dummy \
    x11-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY xorg.conf /etc/X11/xorg.conf

ENTRYPOINT ["Xorg", ":0", "-noreset", "-logfile", "/dev/stdout", "-config", "/etc/X11/xorg.conf", "-nolisten", "tcp", "-ac"]
