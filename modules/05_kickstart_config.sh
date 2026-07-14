#!/bin/bash
# 킥스타트 설정 스크립트 파일

Kickstart() {
	KsFileLoc="/root/anaconda-ks.cfg"
	NewKsFile="/var/www/html/rocky.ks"
	ServerIP=$(hostname -I | awk '{print $1}')

	cp "$KsFileLoc" "$NewKsFile"
	sed -i "s/^repo.*/repo --name=\"AppStream\" --baseurl=http:\/\/$ServerIP\/pub\/AppStream\/\\nurl --url=http:\/\/$ServerIP\/pub/" "$NewKsFile"
	sed -i "s/^network  --bootproto=static.*/network  --bootproto=dhcp/" "$NewKsFile"
	sed -i "/graphical-server-environment/c @^Server with GUI\n@GNOME Applications\nmc\nvim" "$NewKsFile"
	sed -i "s/^rootpw.*/#root/" "$NewKsFile"
	sed -i "s/^user.*/#user/" "$NewKsFile"
	sed -i "s/^cdrom/#cdrom/ "$NewKsFile"

	read -p "사용 할 사용자 계정의 이름을 입력하세요(예:rocky).: " UserName
	read -p "사용 할 사용자 계정의 비밀번호 입력하세요.: " Password
	Hashed=$(openssl passwd -6 $Password)
	sed -i "s|^#user|user --groups=wheel --name=$UserName --password=$Hashed --iscrypted --gecos=\"$UserName\"|" "$NewKsFile"
	echo "reboot" >> "$NewKsFile"

	cat "$NewKsFile"
	chmod 644 "$NewKsFile"
	echo "[설정 완료] 킥스타트 파일 설정 완료"
}
