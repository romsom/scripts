#!/bin/bash
# pw: aufschleuen

#mkdir engineering
#mv *.rar engineering/

#ls | grep \.rar | sed "s/^/rar x -p$1 /" | sh


zip_archives=(`ls | grep "\.zip"`)
#echo "${rar_archives[@]}"

for filename in "${zip_archives[@]}" ; do
	unzip $filename -x file_id.diz air.nfo
done

