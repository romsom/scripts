qemu-system-x86_64 -enable-kvm -M q35 -m 16384 -cpu host -smp 24,sockets=1,cores=24,threads=1 \
-bios /usr/share/qemu/bios.bin \
-vga none -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1 -device vfio-pci,host=04:00.0,bus=root.1,addr=00.0,multifunction=on,x-vga=on -device vfio-pci,host=04:00.1,bus=root.1,addr=00.1 \
-device piix4-ide,bus=pcie.0,id=piix4-ide -drive file=/dev/sdb,id=disk,format=raw -device ide-hd,bus=piix4-ide.0,drive=disk \
-usbdevice tablet -vnc :1 -usb \
-device usb-host,hostbus=1,hostaddr=4
