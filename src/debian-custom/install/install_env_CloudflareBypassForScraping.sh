#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

# Set environment variables to avoid interactive prompts during build
export DEBIAN_FRONTEND=noninteractive
export DOCKERMODE=true

# Install necessary packages for Xvfb and pyvirtualdisplay
apt-get update && \
    apt-get install -y \
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

# Upgrade pip and install dependencies inside the virtual environment
# Install Python dependencies including pyvirtualdisplay
pip3 install --upgrade pip
pip3 install pyvirtualdisplay

# Clean up
apt-get clean -y
