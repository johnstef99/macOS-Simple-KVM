#!/bin/bash
#
# Bind usb to vfio so macos can use it
#


VID="1022 149c"
DEVICE="0000:2d:00.3"

# linux
bindToXhci(){
  echo $DEVICE > /sys/bus/pci/devices/$DEVICE/driver/unbind
  echo $DEVICE > /sys/bus/pci/drivers/xhci_hcd/bind
}

# macos
bindToVfio(){
  modprobe vfio-pci
  echo $VID > /sys/bus/pci/drivers/vfio-pci/new_id
  echo $DEVICE > /sys/bus/pci/devices/$DEVICE/driver/unbind
  echo $DEVICE > /sys/bus/pci/drivers/vfio-pci/bind
}

[ -z $1 ] && echo "Binding to vfio" && bindToVfio && exit
echo "Binding back to system"
bindToXhci
