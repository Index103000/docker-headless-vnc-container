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


# Create a Python virtual environment
python3 -m venv /opt/venv

# Activate the virtual environment
source /opt/venv/bin/activate


# Upgrade pip and install dependencies inside the virtual environment
pip3 install --upgrade pip

# 以后在该环境中运行 Python 代码时，记得通过 source /opt/venv/bin/activate 激活虚拟环境
# Install Python dependencies inside the virtual environment
pip3 install pyvirtualdisplay

# Clean up apt cache to reduce image size
apt-get clean -y

# Deactivate the virtual environment (optional, can be done when you exit the script)
deactivate
