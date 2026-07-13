#!/bin/bash
# 방화벽 설정용 스크립트 파일

FirewallCmd() {
	echo ">>> 방화벽 설정 스크립트입니다."

	(rpm -q firewalld && systemctl status firewalld | grep "active (running)")>/dev/null
	if [[ $? -ne 0 ]]; then
		echo "[오류 002] 방화벽이 작동중이지 않습니다."
		exit 1
	else
		echo "TFTP 프로토콜 통신을 위해 방화벽에 등록 중 입니다."
        firewall-cmd --permanent --add-port=66/tcp 
        firewall-cmd --permanent --add-port=67/tcp
        firewall-cmd --permanent --add-port=69/udp
		echo "HTTP 프로토콜 통신을 위해 방화벽에 등록 중 입니다."
        firewall-cmd --permanent --add-port=80/tcp
		firewall-cmd --reload
		firewall-cmd --list-all
		echo "정상 등록되었습니다."
	fi
}
