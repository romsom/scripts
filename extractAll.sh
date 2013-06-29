#!/bin/bash
#echo "#!/bin/sh" > temp.sh
# erzeuge skript aus Dateinamen. fuege in jeder Zeile den Befehl mit pass ein
#ls | grep part1 | sed "s/^/unrar x -p$1 /" >> temp.sh
#chmod +x temp.sh
#sh temp.sh
#rm temp.sh
ls | grep part1 | sed "s/^/unrar x -p$1 /" | sh
#oder so?
#find -name "*part1*" | unrar x -p$1 -
