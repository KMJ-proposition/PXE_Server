#!/bin/bash
# 킥스타트 파일 설정

Kickstart() {
	KsFileLoc="/root/anaconda-ks.cfg"
	NewKsFile="rocky.ks"

	cp $KsFileLoc $PxeFileLoc/$NewKsFile	# 킥스타트 파일	준비
	echo "킥스타트 파일이 $PxeFileLoc 위치로 복사 완료되었습니다."

	grep -n '^repo' $PxeFileLoc/$NewKsFile | cut -b1 | sed -i 's/^repo/#repo/g' $PxeFileLoc/$NewKsFile | grep '#repo'
	#		 	-----	 		#
	#
	# TODO: grep items, replace items
	#
	#		 	----- 			#
	

	grep -nE "repo" $PxeFileLoc/$NewKsFile | cut -b1 | wc -l
	if [[ $? -ne 1 ]]; then
		sed 's/^repo.*$/url --url=http://$InstallFileLoc'
		grep '^url'
	fi
}
