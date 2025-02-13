## docker 部署

```sh
# 部署基本环境，这里以根目录下创建 /docker 目录作为工作目录
mkdir /docker
cd /docker

# 创建代码调试目录
mkdir -p /docker/code && \
cd /docker/code

# 拉取项目代码（切换 test 分支上）
git clone https://github.com/Index103000/docker-headless-vnc-container.git && \
cd docker-headless-vnc-container && \
git checkout test && \

# 镜像构建
# 基于 docker-compose.yml 构建镜像
cd /docker/code/docker-headless-vnc-container/docker && \
docker compose build debian-xfce-vnc-custom

# 基于 Dockerfile 构建镜像
cd /docker/code/docker-headless-vnc-container/docker && \
docker build -t index103000/debian-xfce-vnc-custom:v1.0.0 ./Dockerfile.debian-xfce-vnc-custom

# 运行容器
cd /docker/code/docker-headless-vnc-container/docker && \
docker compose up -d debian-xfce-vnc-custom

# 查看容器日志（-f 实时）
# -f 或 --follow：跟随日志输出，实时显示容器日志的新增部分。
# --tail 10：表示只查看容器日志的最后 10 行。
docker logs -f --tail 50 debian-xfce-vnc-custom

# 使用 docker tag 命令为构建的镜像添加 latest 标签
docker tag index103000/debian-xfce-vnc-custom:v1.0.0 index103000/debian-xfce-vnc-custom:latest

# 镜像推送
docker login -u index103000
docker push index103000/debian-xfce-vnc-custom:v1.0.0
docker push index103000/debian-xfce-vnc-custom:latest

# 清理镜像临时文件
docker image prune

# 查看docker资源占用情况
docker stats

```

