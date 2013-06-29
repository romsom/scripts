#!/bin/bash

## m3u_convert.sh

# A script to convert files from a m3u playlist from wav to flac. Useful e.g. when someone forgot to put the tracknumber in the WAV's filename (WAVs don't have tags...).

OLD_IFS=$IFS
IFS="
"
codepage="ISO-8859-15"
format="wav"
playlist=`cat $1`

typeset -i index=1

for line in ${playlist[@]}; do
	if [[ "$line" != "#"* ]]; then # leave comments out
## das grenzt an schwarze magie... aber nur so funktionierts:
		line="${line%.*}.$format"
		if [ $codepage != "UTF-8" ]; then
			line=`echo $line | iconv --from-code=$codepage --to-code=UTF-8`
#			echo $line
		fi
		output_file="`printf "%02d" $index`-${line%.*}.flac"
#		echo $output_file
		flac -V "$line" -o "$output_file"
		let index++
	fi
done


IFS=$OLD_IFS
