#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

# Install necessary packages for Xvfb and xephyr
# Temporarily override DEBIAN_FRONTEND only for this installation step，to avoid interactive prompts during build
# xvfb：用于在无头环境中运行虚拟显示服务器，它不会显示任何界面，但可以作为后台服务支持图形化应用程序（如浏览器、Selenium等）。
# xserver-xephyr：用于创建可视化的虚拟显示，它提供了一个完整的图形化界面，适用于需要显示桌面环境的应用。
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
        xvfb \
        xserver-xephyr

# Clean up apt cache to reduce image size
apt-get clean -y
