#!/bin/bash
# 킥스타트 설정 스크립트 파일

Kickstart() {
	KsFileLoc="/root/anaconda-ks.cfg"
	NewKsFile="/var/www/html/rocky.ks"
	ServerIP=$(hostname -I)

	cp "$KsFileLoc" "$NewKsFile"
	sed -i "s/^repo.*/repo --name=\"AppStream\" --baseurl=http:\/\/$ServerIP\/pub\/AppStream/\\nurl --url=http:\/\/$ServerIP\/pub/" "$NewKsFile"
	sed -i "s/^network  --bootproto=static.*/network  --bootproto=dhcp/" "$NewKsFile"
	cutLine=$(grep -nE "graphical-server-environment" "$NewKsFile" | cut -d: -f1)
	sed -i "${cutLine}a @GNOME Applications\nmc\nvim" "$NewKsFile"
	sed -i "s/^rootpw.*/#root/" "$NewKsFile"
	sed -i "s/^user.*/#user/" "$NewKsFile"

	read -p "사용 할 사용자 계정의 이름을 입력하세요(예:rocky).: " UserName
	read -p "사용 할 사용자 계정의 비밀번호 입력하세요.: " Password
	useradd -m -p $(openssl passwd -6 "$Password") "$UserName"
	Password=$(getent shadow "$UserName" | cut -d: -f2)
	sed -i "s|^#user|user --groups=wheel --name=$UserName --password=$Password --iscrypted --gecos=\"$UserName\"|" "$NewKsFile"
	echo "reboot" >> "$NewKsFile"
	userdel -r $UserName

	cat "$NewKsFile"
	chmod 644 "$NewKsFile"
	echo "[설정 완료] 킥스타트 파일 설정 완료"
}
