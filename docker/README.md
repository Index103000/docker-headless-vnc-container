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



问题汇总：

1. 构建时，找不到文件

   要清理 Docker 缓存并重新构建镜像，您可以按照以下步骤操作：

   1. **清理未使用的镜像、容器、网络和卷**：

      ```bash
      docker system prune -a
      ```

      该命令会删除所有未使用的镜像、停止的容器、未使用的网络和悬挂的卷。如果您只想删除未使用的镜像，可以使用：

      ```bash
      docker image prune -a
      ```

   2. **强制清理构建缓存**： 如果您只想清理构建时产生的缓存，可以使用：

      ```bash
      docker builder prune
      ```

      该命令会清理构建过程中生成的所有缓存，包括中间镜像和无效缓存层。

   3. **重新构建镜像**： 运行以下命令重新构建 Docker 镜像：

      ```bash
      docker build --no-cache -t <your_image_name> .
      ```

      `--no-cache` 参数可以确保重新构建时不使用任何缓存层。

   这些操作将帮助您清理不再需要的 Docker 资源，并确保使用最新的构建过程。

   

2. 构建时，文件权限受限

   1. 大概率是在 windows 上编辑的文件直接在 linux 上使用导致的，在 linux 上赋予可执行权限就行

      ```sh
      chmod +x 文件.sh
      ```

      注意：修改完成权限后，通过 linux 上传 git，这样 windows 再拉取下来以后就都是可执行的了

3. 构建时，执行 sh 文件失败

   1. 大概率是在 windows 上编辑时，被修改了 换行符 由 CRLF 修改为 LF 即可

4. 若有需要手动确认的操作，一律要加上 -y 来自动确认执行，否则会停止构建

5. 其他

