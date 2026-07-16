#!/bin/bash
# 패키지 설치용 스크립트 파일

PackInstall() {
	echo ">>> 패키지 설치 스크립트입니다."

	ping -c 1 168.126.63.1 > /dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		echo "[오류 001] 네트워크에 연결되어 있지 않습니다."
		exit 1
	else
		echo ">>> 네트워크에 연결되어 있습니다."
	fi

	read -p "패키지를 설치하시겠습니까?[y/N] " Install
	case $Install in
		Y|y|YES|Yes|yes)
			echo ">>> 패키지 설치를 진행합니다."
			dnf install -y syslinux httpd tftp-server dhcp-server
			systemctl enable --now httpd tftp
			echo "[설정 완료] 패키지를 실행하였습니다."
			;;
		*)
			echo ">>> 설치를 취소합니다."
			;;
	esac
}