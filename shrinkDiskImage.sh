#!/bin/bash

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

if [[ $EUID -ne 0 ]]; then
    echo "You must be a root user" 
    exit 1
else
    echo "You are root"
fi

LBIMG=$(losetup -f)
losetup $LBIMG $1
partprobe $LBIMG 
gparted $LBIMG
losetup -d $LBIMG
END=$(fdisk -l $1 | tail -n 1 | tr -s '[:blank:]' ','| cut -d ',' -f 3)
truncate --size=$[($END+1)*512] $1
echo "prout"
