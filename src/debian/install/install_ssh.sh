#!/usr/bin/env bash

# 更新软件包列表并安装 openssh-server
apt-get update && apt-get install -y openssh-server

# 创建 SSH 服务所需的目录
mkdir -p /var/run/sshd

# 修改 SSH 配置文件，允许 root 用户通过密码登录
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
