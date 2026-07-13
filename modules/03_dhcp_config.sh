#!/bin/bash
# DHCP 설정용 스크립트 파일

DhcpConfig() {
	(rpm -q dhcp-server && systemctl status dhcpd)>/dev/null
	if [[ $? -ne 0 ]]; then
		echo "[오류 003] DHCP 서버가 작동중이지 않습니다."
		exit 1
	else
		read -p "네트워크를 입력하세요.: " Network
		read -p "서브넷마스크를 입력하세요.: " Subnet
		read -p "게이트웨이 IP를 입력하세요.: " Gateway
		read -p "PXE 서버의 IP를 입력하세요.: " PxeServer
		read -p "DHCP 할당 시작 범위를 입력하세요.: " DhcpStart
		read -p "DHCP 할당 끝 범위를 입력하세요.: " DhcpEnd
		read -p "DNS 주소를 입력하세요.: " DnsAddress

		echo -e "subnet $Network	netmask $Subnet {\n    allow booting;\n    allow bootp;
    default-lease-time 600;\n    max-lease-time 7200;\n    next-server $PxeServer;
    option routers $Gateway;\n    option subnet-mask $Subnet;
    option domain-name-servers $DnsAddress;\n    range $DhcpStart $DhcpEnd;
    filename 'pxelinux.0';\n}" >> /etc/dhcp/dhcpd.conf

		cat /etc/dhcp/dhcpd.conf
	fi
}
