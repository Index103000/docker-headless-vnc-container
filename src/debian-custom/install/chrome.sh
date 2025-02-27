#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Chrome Browser"
# Setup key 设置密钥
# 下载并安装 Google 的 GPG 密钥： Google 使用 GPG 密钥来验证下载的软件包的完整性。你可以通过以下命令下载并安装该密钥：
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# Setup repository 设置存储库
# 添加 Google 的软件源，因为默认的 Debian 软件源中没有 Google Chrome
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# 更新软件源
sudo apt-get update

# 未配置 存储库 或 存储库 未正常拉取内容 的情况下执行安装 google-chrome-stable，会报错：E: Unable to locate package google-chrome-stable
sudo apt-get install google-chrome-stable

# 清理安装残留
apt-get clean -y
