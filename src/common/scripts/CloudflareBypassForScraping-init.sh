#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo -e "\n------------------ init CloudflareBypassForScraping env ------------------"
# Install Python dependencies including pyvirtualdisplay
pip3 install --upgrade pip
pip3 install pyvirtualdisplay
