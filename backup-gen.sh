#!/bin/bash

PROG="Backup Generator"
VERSION="0.1.3"

DATE=$(date +%Y-%m-%d)
NAME=$(hostname)-$DATE

echo "$PROG" "$VERSION"
mkdir -p "$NAME/"

echo "Erstelle Paketlisten ..."

mkdir "$NAME/pkg"

# find foreign packages
pacman -Qm > "$NAME/pkg/aurpackages"

# find explicityly installed repo packages sorted by groups
pkggroups="$(pacman -Qg | cut -d' ' -f1 | sort -u)"
echo "${pkggroups}" | while read -r pkggroup; do
    pacman -Qeg "$pkggroup" | cut -d' ' -f2 > "$NAME/pkg/pkglist.$pkggroup"
done

# find explicitly installed packages from the repos not belonging to any group
pacman -Qeq | grep -v "$(echo "${pkggroups}" | xargs -d'\n' pacman -Sqg)" | grep -v "$(pacman -Qmq || echo " ")" > "$NAME/pkg/pkglist"
# enable this line to check tests
#pacman -Qeq | grep -v "$(pacman -Qmq || echo " ")" > "$NAME/pkg/pkglist"

# test output
if [ "$(xargs -d '\n' -a "$NAME/pkg/pkglist" pacman -Qi | grep Groups | grep -v None -c)" -gt 0 ]; then
    echo "Warning: there are packages in pkglist that may belong to a group." >&2
fi

echo "Sichere Systemkonfiguration ..."

mkdir "$NAME/config"
pacman -Qii | awk '/^MODIFIED/ {print $2}' | grep -v "shadow" >> "$NAME/config/configlist"

# generate rsync commandline, $NAME/config/ is the target directory
echo "$NAME/config/" | cat "$NAME/config/configlist" - | xargs -d '\n' rsync -aR

if [ -d /etc/skel ]; then
cp -r /etc/skel "$NAME/config/etc/"
fi

echo "Komprimiere Daten ..."

tar -cJf "$NAME.tar.xz" "$NAME"/*
rm -r "${NAME:?}/"

echo "Fertig!"
