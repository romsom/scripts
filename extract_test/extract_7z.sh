#!/bin/bash
# pw: aufschleuen

#mkdir engineering
#mv *.7z engineering/

#cd engineering
#ls | grep .7z | sed "s/^/7z x -p$1 /" | sh

OLDIFS="$IFS"
IFS="
"
passwords=(`cat passwords.txt`)
IFS="$OLDIFS"


#echo ${passwords[1]}

s7z_archives=(`ls | grep "\.7z"`)
#echo "${s7z_archives[@]}"

for filename in "${s7z_archives[@]}" ; do
	folder=(`echo $filename | sed -e s/.7z.*$//`)
	echo $folder
	mkdir $folder
	mv $filename $folder
	cd $folder

	for pass in "${passwords[@]}" ; do
		echo bla
		if 7z x -p$pass $filename ; then
#			error=""
# passwörter umsortieren:
			pw_tmp=( ${passwords[@]/$pass/} )
			passwords=( "$pass" "${pw_tmp[@]}")
			rm $filename
			break
		fi
	done
	cd ..
done


OLDIFS="$IFS"
IFS="
"
#echo "${s7z_archives[*]}"
echo "${passwords[*]}" > passwords.txt
IFS="$OLDIFS"

