#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

VNC_RES_W=${VNC_RESOLUTION%x*}
VNC_RES_H=${VNC_RESOLUTION#*x}

echo -e "\n------------------ update chromium-browser.init ------------------"
echo -e "\n... set window size $VNC_RES_W x $VNC_RES_H as chrome window size!\n"

echo "export CHROMIUM_FLAGS='--no-sandbox --test-type --start-maximized --disable-gpu --user-data-dir --window-size=$VNC_RES_W,$VNC_RES_H --window-position=0,0'" > $HOME/.chromium-browser.init

# 由于 chrome 无法启动，因而暂时通过如下配置临时解决，参见：https://github.com/ConSol/docker-headless-vnc-container/issues/209
# 另外，由于 容器启动时，扩充了 共享内存 大小，由默认 64m 配置成 shm_size: '2g'，因而不需要再配置 --disable-dev-shm-usage 禁用共享内存了，提高运行效率
# chromium
echo "export CHROMIUM_FLAGS='--no-sandbox --test-type --start-maximized --disable-gpu --user-data-dir --window-size=$VNC_RES_W,$VNC_RES_H --window-position=0,0'" | tee -a /etc/chromium.d/default-flags > /dev/null


# 下面配置 chrome 桌面图标文件
echo -e "\n------------------ config google-chrome.desktop ------------------"
# 目标路径
desktop_file="/usr/share/applications/google-chrome.desktop"
desktop_copy="$HOME/Desktop/google-chrome.desktop"

# 复制 .desktop 文件到桌面
cp "$desktop_file" "$desktop_copy"

# 检查文件是否成功复制
if [ ! -f "$desktop_copy" ]; then
    echo "google-chrome.desktop file copy failed, exit!"
    exit 1
fi

# 修改 Exec 行，加入自定义参数，确保变量被正确替换
sed -i "s|^Exec=.*|Exec=/usr/bin/google-chrome-stable --no-sandbox --test-type --start-maximized --disable-gpu --user-data-dir --window-size=${VNC_RES_W},${VNC_RES_H} --window-position=0,0 %U|" "$desktop_copy"

# 自定义启动参数及其作用的详细解释：
  #
  #1. **`--no-sandbox`**
  #   禁用沙箱模式。Chrome 的沙箱模式用于隔离进程并增加安全性，但某些环境（如自动化测试环境）可能需要禁用它。这个参数通常用于在没有图形界面的环境中（例如服务器或虚拟机）运行 Chrome 时，避免沙箱引发错误。
  #
  #2. **`--test-type`**
  #   启用测试模式。这个参数常用于自动化测试场景，尤其是使用 Selenium 或其他自动化工具时。它会影响 Chrome 的一些行为，通常用于避免启动时的某些提示和警告信息。
  #
  #3. **`--start-maximized`**
  #   启动时将 Chrome 窗口最大化。无论显示器的分辨率如何，浏览器会尽量在启动时占据整个屏幕区域。
  #
  #4. **`--disable-gpu`**
  #   禁用 GPU 加速。GPU 加速可以加快图形渲染，但在某些环境中（例如虚拟机或没有硬件加速的服务器环境）可能会导致性能问题或者启动失败。使用此参数可以避免依赖 GPU 来提高兼容性。
  #
  #5. **`--user-data-dir`**
  #   指定用户数据目录。Chrome 存储浏览历史、缓存、扩展和用户配置文件等数据。这个参数允许你指定一个自定义目录来存储这些数据，而不是使用默认位置。使用此参数时，通常还需要指定一个具体的路径。例如：
  #
  #   ```bash
  #   --user-data-dir=/path/to/custom/profile
  #   ```
  #   如果不指定 `--user-data-dir`，Chrome 会使用默认的用户数据目录，这个目录通常在不同操作系统中有所不同：
  #
  #     - 在 **Linux** 系统中，默认路径为 `~/.config/google-chrome/`。
  #     - 在 **Windows** 系统中，默认路径为 `C:\Users\<YourUsername>\AppData\Local\Google\Chrome\User Data`。
  #     - 在 **macOS** 系统中，默认路径为 `/Users/<YourUsername>/Library/Application Support/Google/Chrome`。
  #
  #6. **`--window-size=$VNC_RES_W,$VNC_RES_H`**
  #   设置浏览器窗口的大小。这个参数指定了启动时窗口的宽度和高度。`$VNC_RES_W` 和 `$VNC_RES_H` 是环境变量，通常代表你希望 Chrome 启动时的分辨率（宽度和高度）。比如，`--window-size=1280,1024` 将启动一个 1280x1024 的浏览器窗口。如果这些变量没有设置，则可以使用默认的分辨率。
  #
  #   同时使用 --start-maximized --window-size=1280,1024 这两个参数，`--start-maximized` 会被忽略，Chrome 会优先使用 `--window-size` 设置的窗口大小。
  #
  #7. **`--window-position=0,0`**
  #   设置浏览器窗口的位置。这个参数指定了窗口的起始位置，单位是像素，`0,0` 表示将窗口放置在屏幕的左上角。你可以根据需要调整窗口的位置，例如：
  #
  #   ```bash
  #   --window-position=100,100
  #   ```
  #
  #   将使浏览器窗口位于屏幕的 (100, 100) 坐标位置。