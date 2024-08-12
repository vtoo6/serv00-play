#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'

installpath="$HOME"
art_wrod=$(figlet "serv00-play")
echo "<------------------------------------------------------------------>"
echo -e "${CYAN}${art_wrod}${RESET}"
echo -e "${WRITE} 饭奇骏频道:https://www.youtube.com/@frankiejun8965 ${RESET}"
echo -e "${WRITE} TG交流群:https://t.me/fanyousuiqun ${RESET}"
echo "<------------------------------------------------------------------>"

install(){
	cd 
	if [ -d serv00-play ]; then
		echo -e "${RED}请勿重复安装!${RESET}"
		exit 1
  fi
	echo "正在安装..."
	if ! git clone https://github.com/frankiejun/serv00-play.git; then
		echo -e "${RED}安装失败!${RESET}"
		exit 1;
  fi
	echo -e "${YELLOW}安装成功${RESET}"
}

checkvlessAlive(){
	if  ps  aux | grep app.js | grep -v "grep" ; then
		return 0
  else 
		return 1
	fi	
}

checkvmessAlive(){
	local c=0
	if ps  aux | grep web.js | grep -v "grep" > /dev/null ; then
		((c+1))
	fi

	if ps aux | grep cloud | grep -v "grep" > /dev/null ; then
		((c+1))
	fi	
	if ps aux | grep server.js | grep -v "grep" > /dev/null ; then
		((c+1))
	fi	

	echo "c=$c"
	if [ $c -eq 3 ]; then
		return 0
	fi

	return 1 # 有一个或多个进程不在运行

}

startvless(){
	cd ${installpath}/serv00-play/vless
	
	if checkvlessAlive; then
		echo -e "${RED}vless 已在运行，请勿重复操作!${RESET}"
		exit 1
	fi

	if ! ./start.sh; then
		echo e "${RED}vless启动失败！${RESET}"
		exit 1
	fi

	echo -e "${YELLOW}启动成功!${RESET}"

}

startvmess(){
	cd ${installpath}/serv00-play/vmess
	
	if checkvmessAlive; then
		echo -e "$RED}vmess 已在运行，请勿重复操作!${RESET}"
		exit 1
	else
		chmod 755 ./killvmess.sh
		./killvmess.sh
	fi

	if ! ./start.sh; then
		echo "vmess启动失败！"
		exit 1
	fi

	echo -e "${YELLOW}启动成功!${RESET}"

}

stopvless(){
	r=$(ps aux | grep app.js | grep -v "grep" | awk '{print $2}' ) 
	if [ -z "$r" ]; then
		echo "没有运行!"
		exit 0
	else	
		kill -9 $r
	fi
	echo "已停掉vless!"
}

stopvmess(){
	cd ${installpath}/serv00-play/vmess
	if [ -f killvmess.sh ]; then
		chmod 755 ./killvmess.sh
		./killvmess.sh
	else
		echo "请先安装serv00-play!!!"
		exit 1
	fi
	echo "已停掉vmess!"
}

echo "请选择一个选项:"

options=("安装serv00-play项目" "运行vless" "运行vmess" "停止vless" "停止vmess" "退出")

select opt in "${options[@]}"
do
    case $opt in
        "安装serv00-play项目")
					  install
            ;;
        "运行vless")
				    read -p "请确认${installpath}/serv00-play/vless/start.sh 已配置完毕 (y/n) [y]?" input
						input=${input:-y}
						if [ "$input" != "y" ]; then
							echo "请先进行配置!!!"
							exit 1
						fi
            startvless
            ;;
        "运行vmess")
				    read -p "请确认${installpath}/serv00-play/vmess/start.sh 已配置完毕 (y/n) [y]?" input
						input=${input:-y}
						if [ "$input" != "y" ]; then
							echo "请先进行配置!!!"
							exit 1
						fi
						startvmess
            ;;
        "停止vless")
            stopvless
            ;;
        "停止vmess")
            stopvmess
            ;;
        "退出")
            echo "退出"
            break
            ;;
        *) 
            echo "无效的选项 "
            ;;
    esac
done
