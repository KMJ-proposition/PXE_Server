#!/bin/bash
# 킥스타트 파일 설정

Kickstart() {
	KsFileLoc="/root/anaconda-ks.cfg"
	NewKsFile="/var/www/html/rocky.ks"

	cp $KsFileLoc $NewKsFile	# 킥스타트 파일	준비
	echo "[설정 완료] 킥스타트 파일이 $PxeFileLoc 위치로 복사 완료되었습니다."

	cutLine=$(grep -n '^url' $NewKsFile | cut -d: -f1)
	sed -i "${cutLine}c url --url=http://192.168.10.100/pub" $NewKsFile | grep -En "^url|^repo"
	echo "[설정 완료] 파일 전송용 HTTP 주소 등록 완료"

	cutLine=$(grep -n '^repo' $NewKsFile | cut -d: -f1)
	sed -i "${cutLine}c repo --name=\"AppStream\" --baseurl=http://192.168.10.100/pub/AppStream" $NewKsFile | grep -En "^url|^repo"
	echo "[설정 완료] 파일 전송용 repo 주소 등록 완료"

	cutLine=$(grep -n '^network  --bootproto' $NewKsFile | cut -d: -f1)
	sed -i "${cutLine}c network  --bootproto=dhcp  --hostname=Rocky" $NewKsFile | grep -En "^network"
	echo "[설정 완료] 클라이언트 PC의 주소 DHCP로 설정 완료"

	cutLine=$(grep -nE "^\%packages" $NewKsFile | cut -d: -f1)
	sed -i "${cutLine}a \n@^Server with GUI\@GNOME Applications\nmc\nvim" $NewKsFile | grep -nE "packages" -A5
	echo "[설정 완료] 클라이언트 PC에 설치할 기본 키지 설정 완료"

	cutLine=$(grep -n "^rootpw" $NewKsFile | cut -d: -f1)
	sed -i "${cutLine}c #" $NewKsFile | grep -n "^rootpw"
	cutLine=$(grep -n "^user" $NewKsFile | cut -d: -f1)
	sed -i "${cutLine}c #user" $NewKsFile | grep -n "^#user"
	echo "[설정 완료] 클라이언트 PC의 root, 사용자 계정의  비밀번호 삭제 및 초기화 완료"

	cutLine=$(grep -n "^user" $NewKsFile | cut -d: -f1)
	sed "${cutLine}c #user" $NewKsFile | grep -n "^#user"
	read -p "사용할 사용자 계정 이름을 입력하세요(예:rocky).: " UserName
	read -p "사용자 계정의 비밀번호 입력하세요.: " Password
	useradd -m -p $(openssl passwd -6 "$Password") $UserName
	Password=$(getent shadow rocky | cut -d: -f2)
	
	cutLine=$(grep -n "^#user" $NewKsFile | cut -d: -f1)
	sed -i "${cutLine}c user --groups=wheel --name=$UserName --password=$Password --iscrypted --gecos="$UserName"" $NewKsFile
	echo "[설정 완료] 클라이언트 PC의 사용자 계정 초기화 완료"

	echo -e "\n\nreboot" >> $NewKsFile
	echo "[설정 완료] OS 설치 후 자동 재부팅 설정 완료"
}
