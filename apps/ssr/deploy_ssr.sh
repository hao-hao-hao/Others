#Require Root Permission
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

install_ssr(){
	cd /root/
	echo 'downloading the ssr and set up cymysql'
	apt install unzip
	wget -c https://github.com/Hao-Luo/Others/raw/master/apps/ssr/ssr.zip && unzip ssr.zip && cd shadowsocksr &&  ./setup_cymysql.sh 
	echo 'setting up the ssr'
	stty erase '^H' && read -p " mysql-server address:" mysqlserver
	stty erase '^H' && read -p " mysql-server username:" username
	stty erase '^H' && read -p " mysql-server password:" password
	stty erase '^H' && read -p " ssr node id:" nodeid
	sed -i -e "s/server/$mysqlserver/g" usermysql.json
	sed -i -e "s/username/$username/g" usermysql.json
	sed -i -e "s/password/$password/g" usermysql.json
	sed -i -e "s/node/$nodeid/g" usermysql.json
	echo 'setting up the ssr as service in systemd'
	cp ssr.service /etc/systemd/system/ssr.service
	systemctl daemon-reload
	systemctl start ssr.service
	systemctl enable ssr.service
	echo 'SSR Service is installed'
}
open_bbr(){
	cd
	wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
	chmod +x bbr.sh
	./bbr.sh

}

echo ' 1. Install SSR 2. Open BBR'
stty erase '^H' && read -p " 请输入数字 [1-2]:" num
case "$num" in
	1)
	install_ssr
	;;
	2)
	open_bbr
	;;
	*)
	echo "请输入正确数字 [1-2]"
	;;
esac
