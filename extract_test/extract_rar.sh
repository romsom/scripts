#!/bin/bash
# pw: aufschleuen

#mkdir engineering
#mv *.rar engineering/

#cd engineering
#ls | grep \.rar | sed "s/^/rar x -p$1 /" | sh

OLDIFS="$IFS"
IFS="
"
passwords=(`cat passwords.txt`)
IFS="$OLDIFS"


#echo ${passwords[1]}

rar_archives=(`ls | grep "\.rar" | grep -v "part[0-9]"`)
#echo "${rar_archives[@]}"

for filename in "${rar_archives[@]}" ; do
	folder=(`echo $filename | sed -e s/.rar.*$//`)
	echo $folder
	mkdir $folder
	mv $filename $folder
	cd $folder

	for pass in "${passwords[@]}" ; do
		echo bla
		if unrar x -p$pass $filename ; then
#			error=""
# passwörter umsortieren:
			pw_tmp=( ${passwords[@]/$pass/} )
			passwords=( "$pass" "${pw_tmp[@]}")
#			rm $filename
			break
		fi
	done
	cd ..
done


OLDIFS="$IFS"
IFS="
"
#echo "${rar_archives[*]}"
echo "${passwords[*]}" > passwords.txt
IFS="$OLDIFS"

