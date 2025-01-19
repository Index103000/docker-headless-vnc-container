#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

# Install Python and venv
echo "Install Python 3 and venv"
apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-venv \
        python3-numpy #used for websockify/novnc

# Clean up
apt-get clean -y
