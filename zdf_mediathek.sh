#!/bin/bash

# zdf_mediathek.sh $URL $FILENAME

URL=$1
FILENAME=$2

curl $URL  | grep mms: | cut -d \" -f 2 | xargs -n1 mplayer -dumpstream -dumpfile ~/Videos/$FILENAME.wmv
