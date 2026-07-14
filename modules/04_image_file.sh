#!/bin/bash
# 이미지 파일 마운트 및 복사용 스크립트 파일

ImageFile() {
	InstallFileLoc="/var/www/html/pub"
	BootFileLoc="/var/lib/tftpboot"

	(rpm -q httpd && systemctl status httpd | grep "active (running)")>/dev/null
	if [[ $? -ne 0 ]]; then
		echo "[오류 004] HTTP 서버가 작동중이지 않습니다."
		exit 1
	fi

	if [[ ! -d $InstallFileLoc ]]; then
		mkdir -p $InstallFileLoc
	fi

	umount /dev/cdrom && mount /dev/cdrom $InstallFileLoc | tail -n 5 2>/dev/null
	if [[ $? -ne 0 ]]; then
		echo "이미지 파일이 정상적으로 마운트되지 않았습니다. 이미지를 삽입해주세요."
	else
        cp $InstallFileLoc/images/pxeboot/vmlinuz $BootFileLoc
        cp $InstallFileLoc/images/pxeboot/initrd.img $BootFileLoc
        cp $InstallFileLoc/isolinux/ldlinux.c32 $BootFileLoc
        cp /usr/share/syslinux/pxelinux.0 $BootFileLoc
		chmod 644 /var/www/html/rocky.ks

		mkdir -p $BootFileLoc/pxelinux.cfg/
		touch $BootFileLoc/pxelinux.cfg/default
		echo -e "DEFAULT		Rocky9.6 PXE Install\n\nLABEL		Rocky9.6 PXE Install
	        kernel	vmlinuz
	        APPEND	initrd=initrd.img	inst.repo=http://$ServerIp/pub"
	fi
}
