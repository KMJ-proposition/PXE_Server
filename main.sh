#!/bin/bash
# 0. main.sh
# 1. 패키지 설치 관리자
# 2. 방화벽 설정
# 3. DHCP 설정
# 4. 이미지 파일 마운트 및 복사
# 5. 킥스타트 설정

# modules
source ./modules/01_package_install.sh
source ./modules/02_firewall_config.sh
source ./modules/03_dhcp_config.sh
source ./modules/04_image_file.sh
source ./modules/05_kickstart_config.sh

# Check authentication
Auth="$(id -u)"
if [[ $Auth -ne 0 ]]; then
	echo "[오류 000] 관리자 계정으로 실행해주세요."
fi

# Script Banner
echo ">>> Rocky Linux 9.6 PXE 서버 환경을 구축해주는 스크립트입니다."

while :
do 
	echo "--------------------------------------------------------------"
	echo "1. 패키지 설치"
	echo "2. 방화벽 설정"
	echo "3. DHCP 설정"
	echo "4. 이미지 파일 준비"
	echo "5. 킥스타트 설정"
	echo "0. 종료"
	echo "--------------------------------------------------------------"
	read -p ">>> 메뉴를 선택해주세요: " menu

	case $menu in
		1) # Run module 1 - Package Installer
			PackInstall
			;;
		2) # Run module 2 - Firewalld Config
			FirewallCmd
			;;
		3) # Run module 3 - DHCP Config
			DhcpConfig
			;;
		4) # Run module 4 - Image Mounting & Copy Files
			ImageFile
			;;
		5) # Run module 5 - Kickstart Config
			Kickstart
			;;
		0)
			echo ">>> PXE 환경 구축을 종료합니다."
			exit 0
			;;
	esac	
done

echo -e "\n\n\n테스트용\n\n\n"
