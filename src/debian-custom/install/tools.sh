#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install some common tools for further installation"
apt-get update
apt-get install -y \
        vim \
        wget \
        net-tools \
        locales \
        bzip2 \
        procps \
        apt-utils \
        sudo \
        curl \
        iputils-ping \
        openssl

apt-get clean -y

echo "generate locales für en_US.UTF-8"
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

# 设置 ll 为 ls -l 的别名
echo "alias ll='ls -l'" >> /etc/bash.bashrc