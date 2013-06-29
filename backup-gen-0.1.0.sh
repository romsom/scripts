#!/bin/sh

NAME="Backup Generator"
VERSION="0.1.0"

DATE=$(date +%Y-%m-%d)

echo $NAME $VERSION
mkdir -p $DATE/

echo "Erstelle Paketlisten ..."

mkdir $DATE/pkg

pacman -Qm > $DATE/pkg/pkglist.aur
pacman -Qeq | grep -v "$(pacman -Qqg base base-devel xorg gnome gnome-extra kde libreoffice)" | grep -v "$(pacman -Qqm)" > $DATE/pkg/pkglist
pacman -Qqg xorg > $DATE/pkg/pkglist.xorg
pacman -Qqg gnome > $DATE/pkg/pkglist.gnome
pacman -Qqg gnome-extra > $DATE/pkg/pkglist.gnome-extra
pacman -Qqg kde > $DATE/pkg/pkglist.kde
pacman -Qqg libreoffice > $DATE/pkg/pkglist.libreoffice

echo "Sichere Systemkonfiguration ..."

mkdir $DATE/config

pacman -Qii | awk '/^MODIFIED/ {print $2}' >> $DATE/config/configlist
rsync -R $(cat $DATE/config/configlist) $DATE/config/


echo "Komprimiere Daten ..."

tar -cJf $DATE.tar.xz $DATE/*
rm -r $DATE/

echo "Fertig!"
