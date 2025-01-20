#!/bin/bash
### every exit != 0 fails the script
set -e

## print out help
help (){
echo "
USAGE:
docker run -it -p 6901:6901 -p 5901:5901 consol/<image>:<tag> <option>

IMAGES:
consol/debian-xfce-vnc
consol/rocky-xfce-vnc
consol/debian-icewm-vnc
consol/rocky-icewm-vnc

TAGS:
latest  stable version of branch 'master'
dev     current development version of branch 'dev'

OPTIONS:
-w, --wait      (default) keeps the UI and the vncserver up until SIGINT or SIGTERM will received
-s, --skip      skip the vnc startup and just execute the assigned command.
                example: docker run consol/rocky-xfce-vnc --skip bash
-d, --debug     enables more detailed startup output
                e.g. 'docker run consol/rocky-xfce-vnc --debug bash'
-h, --help      print out this help

Fore more information see: https://github.com/ConSol/docker-headless-vnc-container
"
}
if [[ $1 =~ -h|--help ]]; then
    help
    exit 0
fi

# should also source $STARTUPDIR/generate_container_user
source $HOME/.bashrc

# add `--skip` to startup args, to skip the VNC startup procedure
if [[ $1 =~ -s|--skip ]]; then
    echo -e "\n\n------------------ SKIP VNC STARTUP -----------------"
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '${@:2}'"
    exec "${@:2}"
fi
if [[ $1 =~ -d|--debug ]]; then
    echo -e "\n\n------------------ DEBUG VNC STARTUP -----------------"
    export DEBUG=true
fi

## correct forwarding of shutdown signal
cleanup () {
    kill -s SIGTERM $!
    exit 0
}
trap cleanup SIGINT SIGTERM

## write correct window size to chrome properties
$STARTUPDIR/chrome-init.sh
source $HOME/.chromium-browser.init

## resolve_vnc_connection
VNC_IP=$(hostname -i)

## start ssh
echo -e "\n------------------ start ssh  ----------------------------"
# 设置 root 用户的密码，替换为你的密码
echo 'root:123456' | chpasswd
# Start SSH daemon directly without systemd
/usr/sbin/sshd -D &
# 显示成功消息
echo "SSH 服务已启动，root密码已设置为: 123456"

## change vnc password
echo -e "\n------------------ change VNC password  ------------------"
# first entry is control, second is view (if only one is valid for both)
mkdir -p "$HOME/.vnc"
PASSWD_PATH="$HOME/.vnc/passwd"

if [[ -f $PASSWD_PATH ]]; then
    echo -e "\n---------  purging existing VNC password settings  ---------"
    rm -f $PASSWD_PATH
fi

if [[ $VNC_VIEW_ONLY == "true" ]]; then
    echo "start VNC server in VIEW ONLY mode!"
    #create random pw to prevent access
    echo $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20) | vncpasswd -f > $PASSWD_PATH
fi
echo "$VNC_PW" | vncpasswd -f >> $PASSWD_PATH
chmod 600 $PASSWD_PATH


## start vncserver and noVNC webclient
echo -e "\n------------------ start noVNC  ----------------------------"
if [[ $DEBUG == true ]]; then echo "$NO_VNC_HOME/utils/novnc_proxy --vnc 0.0.0.0:$VNC_PORT --listen $NO_VNC_PORT"; fi
$NO_VNC_HOME/utils/novnc_proxy --vnc 0.0.0.0:$VNC_PORT --listen $NO_VNC_PORT > $STARTUPDIR/no_vnc_startup.log 2>&1 &
PID_SUB=$!

#echo -e "\n------------------ start VNC server ------------------------"
#echo "remove old vnc locks to be a reattachable container"
vncserver -kill $DISPLAY &> $STARTUPDIR/vnc_startup.log \
    || rm -rfv /tmp/.X*-lock /tmp/.X11-unix &> $STARTUPDIR/vnc_startup.log \
    || echo "no locks present"

echo -e "start vncserver with param: VNC_COL_DEPTH=$VNC_COL_DEPTH, VNC_RESOLUTION=$VNC_RESOLUTION\n..."

vnc_cmd="vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION PasswordFile=$HOME/.vnc/passwd"
if [[ ${VNC_PASSWORDLESS:-} == "true" ]]; then
  vnc_cmd="${vnc_cmd} -SecurityTypes None --I-KNOW-THIS-IS-INSECURE"
fi

if [[ $DEBUG == true ]]; then echo "$vnc_cmd"; fi
$vnc_cmd > $STARTUPDIR/no_vnc_startup.log 2>&1

echo -e "start window manager\n..."
$HOME/wm_startup.sh &> $STARTUPDIR/wm_startup.log

## log connect options
echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY= $DISPLAY \n\t=> connect via VNC viewer with $VNC_IP:$VNC_PORT"
echo -e "\nnoVNC HTML client started:\n\t=> connect via http://$VNC_IP:$NO_VNC_PORT/?password=...\n"


# 在这里插入自定义命令，确保在等待之前执行
if [[ -n "$2" ]]; then
    echo -e "\n------------------ EXECUTE ADDITIONAL COMMAND ------------------"
    echo "Executing command: '${@:2}'"
    # 执行传入的命令
    bash -c "${@:2}"
fi


if [[ $DEBUG == true ]] || [[ $1 =~ -t|--tail-log ]]; then
    echo -e "\n------------------ $HOME/.vnc/*$DISPLAY.log ------------------"
    # if option `-t` or `--tail-log` block the execution and tail the VNC log
    tail -f $STARTUPDIR/*.log $HOME/.vnc/*$DISPLAY.log
fi

if [ -z "$1" ] || [[ $1 =~ -w|--wait ]]; then
    wait $PID_SUB
else
    # unknown option ==> call command
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '$@'"
    exec "$@"
fi
