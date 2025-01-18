#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

VNC_RES_W=${VNC_RESOLUTION%x*}
VNC_RES_H=${VNC_RESOLUTION#*x}

echo -e "\n------------------ update chromium-browser.init ------------------"
echo -e "\n... set window size $VNC_RES_W x $VNC_RES_H as chrome window size!\n"

echo "export CHROMIUM_FLAGS='--no-sandbox --test-type --start-maximized --disable-gpu --disable-dev-shm-usage  --user-data-dir --window-size=$VNC_RES_W,$VNC_RES_H --window-position=0,0'" > $HOME/.chromium-browser.init

# 由于 chrome 无法启动，因而暂时通过如下配置临时解决，参见：https://github.com/ConSol/docker-headless-vnc-container/issues/209
echo "export CHROMIUM_FLAGS='--no-sandbox --test-type --start-maximized --disable-gpu --disable-dev-shm-usage --user-data-dir --window-size=\$VNC_RES_W,\$VNC_RES_H --window-position=0,0'" | tee -a /etc/chromium.d/default-flags > /dev/null
