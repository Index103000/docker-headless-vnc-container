#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

# Install necessary packages for Xvfb
# Temporarily override DEBIAN_FRONTEND only for this installation step，to avoid interactive prompts during build
DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        wget \
        gnupg \
        ca-certificates \
        libx11-xcb1 \
        libxcomposite1 \
        libxdamage1 \
        libxrandr2 \
        libxss1 \
        libxtst6 \
        libnss3 \
        libatk-bridge2.0-0 \
        libgtk-3-0 \
        x11-apps \
        fonts-liberation \
        libappindicator3-1 \
        libu2f-udev \
        libvulkan1 \
        libdrm2 \
        xdg-utils \
        xvfb

# Clean up apt cache to reduce image size
apt-get clean -y
