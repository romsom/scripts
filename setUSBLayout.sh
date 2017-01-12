#!/bin/sh

USBDEVICE="HID 046a:0011"
USBLAYOUT="en_US"
INTDEVICE="AT Translated Set 2 keyboard"
INTLAYOUT="de"

setxkbmap -device $(xinput --list --id-only "$USBDEVICE") "$USBLAYOUT"
setxkbmap -device $(xinput --list --id-only "$INTDEVICE") "$INTLAYOUT"
