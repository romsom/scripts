#!/bin/bash

## flac_check v0.12

function echolog() {
	echo $1
	echo $1 >> $LOGFILE
}




OLDIFS=$IFS
IFS="
"
flacs=`find . -name "*\.flac" | sort`
LOGFILE="flac_check.log"

# Logfile anlegen
if [ ! -e $LOGFILE ]; then
	touch $LOGFILE
fi

echolog `date +"%Y-%m-%d %R"`

for flac in ${flacs[@]}; do
#	echo "$flac"
#	echo "$flac" >> flac_check.log
	echolog "$flac"
	
	if flac -t "$flac" 2>/dev/null ; then
#		echo "	-> OK."
#		echo "	-> OK." >> flac_check.log
		echolog "	-> OK."
	else
#		echo "	-> FAIL!"
#		echo "	-> FAIL!" >> flac_check.log
		echolog "	-> FAIL!"
	fi
done

IFS=$OLDIFS
