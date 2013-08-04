#!/bin/sh

PROG="Backup Generator"
VERSION="0.1.1"

DATE=$(date +%Y-%m-%d)
NAME=`hostname`-$DATE

echo $PROG $VERSION
mkdir -p $NAME/

echo "Erstelle Paketlisten ..."

mkdir $NAME/pkg

pacman -Qm > $NAME/pkg/pkglist.aur
# echo ... falls pacman -Qqm ohne Ausgabe
pacman -Qeq | grep -v "$(pacman -Sqg base base-devel xorg gnome gnome-extra kde libreoffice)" | grep -v "$(echo " " && pacman -Qqm)" > $NAME/pkg/pkglist
pacman -Qqg xorg > $NAME/pkg/pkglist.xorg
pacman -Qqg gnome > $NAME/pkg/pkglist.gnome
pacman -Qqg gnome-extra > $NAME/pkg/pkglist.gnome-extra
pacman -Qqg kde > $NAME/pkg/pkglist.kde
pacman -Qqg libreoffice > $NAME/pkg/pkglist.libreoffice

echo "Sichere Systemkonfiguration ..."

mkdir $NAME/config

pacman -Qii | awk '/^MODIFIED/ {print $2}' | grep -v "shadow" >> $NAME/config/configlist
rsync -R $(cat $NAME/config/configlist) $NAME/config/
cp -r /etc/skel $DATE/config/etc/

echo "Komprimiere Daten ..."

# lange her, hat nicht funktioniert, bleibt als reminder
#echo "Erstelle Wiederherstellungsskript ..."
#cat /dev/null >> $NAME/restore.sh
#echo '#!/bin/sh' > $NAME/restore.sh
#echo 'pacman -S $(cat pkg/pkglist)' > $NAME/restore.sh
#echo 'cp --recursive /config/* /' > $NAME/restore.sh
#chmod a+x $NAME/restore.sh

tar -cJf $NAME.tar.xz $NAME/*
rm -r $NAME/

echo "Fertig!"
