#!/bin/bash

## flacinfo.sh

OLDIFS=$IFS
IFS="
"
flacs=`find . -name "*\.flac" | sort`
apes=`find . -name "*\.ape" | sort`
wvs=`find . -name "*\.wv" | sort`
ttas=`find . -name "*\.tta" | sort`
shns=`find . -name "*\.shn" | sort`


#touch flacinfo
#mkdir ../../flac
for flac in ${flacs[@]}; do

	MD5=`metaflac --show-md5 $flac`
	samplerate=`metaflac --show-sample-rate $flac`
	bits=`metaflac --show-bps $flac`
	channels=`metaflac --show-channels $flac`
	new_output_line="$bits-$samplerate: $channels"
	if [ "$new_output_line" != "$old_output_line" ]; then
		echo $new_output_line
		echo $new_output_line >> flacinfo.log
	fi

	new_directory=${flac%\/*}
	if [ "$new_directory" != "$old_directory" ]; then
		echo $new_directory
		echo $new_directory >> flacinfo.log
#cp -R --parents -p "$new_directory" ../../flac/ && rm -R -d "$new_directory"
	fi

#	echo $MD5

	old_output_line=$new_output_line
	old_directory=$new_directory




#	if flac -t "$flac" 2>/dev/null ; then
#		echo "	-> OK."
#		echo "	-> OK." >> flac_check.log
#	else
#		echo "	-> FAIL!"
#		echo "	-> FAIL!" >> flac_check.log
#	fi
done

echo " ==== Folders containing files compressed with ape ==== "
echo " ==== Folders containing files compressed with ape ==== " >> flacinfo.log
for ape in ${apes[@]}; do
	new_directory=${ape%\/*}
	if [ "$new_directory" != "$old_directory" ]; then
		echo $new_directory
		echo $new_directory >> flacinfo.log
#	cp -R --parents -p "$old_directory" /../../ape/ 2>> flacinfo.log && rm -R -d "$old_directory"
	fi
	old_directory=$new_directory
done
echo " ==== Folders containing files compressed with wv ==== "
echo " ==== Folders containing files compressed with wv ==== " >> flacinfo.log
for wv in ${wvs[@]}; do
	new_directory=${wv%\/*}
	if [ "$new_directory" != "$old_directory" ]; then
		echo $new_directory
		echo $new_directory >> flacinfo.log
#	cp -R --parents -p "$old_directory" /../../wv && rm -R -d "$old_directory"
	fi
	old_directory=$new_directory
done
echo " ==== Folders containing files compressed with tta ==== "
echo " ==== Folders containing files compressed with tta ==== " >> flacinfo.log
for tta in ${ttas[@]}; do
	new_directory=${tta%\/*}
	if [ "$new_directory" != "$old_directory" ]; then
		echo $new_directory
		echo $new_directory >> flacinfo.log
#	cp -R --parents -p "$old_directory" /../../tta && rm -R -d "$old_directory"
	fi
	old_directory=$new_directory
done
echo " ==== Folders containing files compressed with shn ==== "
echo " ==== Folders containing files compressed with shn ==== " >> flacinfo.log
for shn in ${shns[@]}; do
	new_directory=${shn%\/*}
	if [ "$new_directory" != "$old_directory" ]; then
		echo $new_directory
		echo $new_directory >> flacinfo.log
#	cp -R --parents -p "$old_directory" /../../shn && rm -R -d "$old_directory"
	fi
	old_directory=$new_directory
done

IFS=$OLDIFS



