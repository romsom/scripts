#!/bin/bash

NAME="Exact Audio Copy"
CATEGORY="AudioVideo"
DESKTOP_FILE="$NAME.desktop"
PREFX=`echo ~/.eac`
EXECUTABLE_PATH="$PREFX/drive_c/Program Files/Exact Audio Copy"
EXECUTABLE_NAME="EAC.exe"

function gen_wine_desktop() {
	touch "$DESKTOP_FILE"
	echo "[Desktop Entry]" >> "$DESKTOP_FILE"
#	echo "[Desktop Entry]"
	echo "Name=$NAME" >> "$DESKTOP_FILE"
#	echo "Exec=env WINEPREFIX="$PREFX" wine "$EXECUTABLE_PATH/$EXECUTABLE_NAME"" >> "$DESKTOP_FILE"
#	echo "Exec=env WINEPREFIX="$PREFX" wine "'C:\\\\windows\\\\command\\\\start.exe /Unix '$PREFX'/dosdevices/c:/users/Public/Start\\ Menu/Programs/Exact\\ Audio\\ Copy/Exact\\ Audio\\ Copy.lnk' >> "$DESKTOP_FILE"
	echo "Exec=env WINEPREFIX="$PREFX" wine "'C:\\\\windows\\\\command\\\\start.exe /Unix '$PREFX'/drive_c/users/Public/Start\\ Menu/Programs/Exact\\ Audio\\ Copy/Exact\\ Audio\\ Copy.lnk' >> "$DESKTOP_FILE"
	echo "Type=Application" >> "$DESKTOP_FILE"
	echo "StartupNotify=true" >> "$DESKTOP_FILE"
	echo "Path=$EXECUTABLE_PATH/Microsoft.VC80.CRT" >> "$DESKTOP_FILE"
	echo "Categories=$CATEGORY;" >> "$DESKTOP_FILE"
}

if [ -e "$DESKTOP_FILE" ]; then
	echo "$DESKTOP_FILE already exists. Delete it if you want to generate a new one."
else
	gen_wine_desktop
	echo "Möchten Sie die erstellte Verknüpfung installieren? [j/N]"
	read JANEIN
	if [[ $JANEIN == [jJ] ]]; then
		echo "Installiere..."
		desktop-file-install "$DESKTOP_FILE" --dir="`echo ~`/.local/share/applications/$CATEGORY"
		rm "$DESKTOP_FILE"
	fi
	echo "Fertig!"
fi
