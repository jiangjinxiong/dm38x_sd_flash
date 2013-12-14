#!/bin/bash

if [[ -z $1 || -z $2 || -z $3 || -z $4 ]]
then
	echo "mksd-ti814x Usage:"
	echo "	mksd-ti814x <device> <MLO> <u-boot.bin> <uImage> <rootfs tar.gz >"
	echo "	Example: mksd-ti814x /dev/sdc MLO u-boot.bin uImage nfs.tar.gz"
	exit
fi

if ! [[ -e $2 ]]
then
	echo "Incorrect MLO location!"
	exit
fi

if ! [[ -e $3 ]]
then
	echo "Incorrect u-boot.bin location!"
	exit
fi

if ! [[ -e $4 ]]
then
	echo "Incorrect uImage location!"
	exit
fi

if ! [[ -e $5 ]]
then
	echo "Incorrect rootfs location!"
	exit
fi

echo "All data on "$1" now will be destroyed! Continue? [y/n]"
read ans
if ! [ $ans == 'y' ]
then
	exit
fi

echo "[Partitioning $1...]"

DRIVE=$1
dd if=/dev/zero of=$DRIVE bs=1024 count=1024
	 
SIZE=`fdisk -l $DRIVE | grep Disk | awk '{print $5}'`
	 
echo DISK SIZE - $SIZE bytes
 
CYLINDERS=`echo $SIZE/255/63/512 | bc`
 
echo CYLINDERS - $CYLINDERS
{
echo ,9,0x0C,*
echo 10,,,-
} | sfdisk -D -H 255 -S 63 -C $CYLINDERS $DRIVE

echo "[Making filesystems...]"

mkfs.vfat -F 32 -n boot "$1"1 &> /dev/null
mkfs.ext3 -L rootfs "$1"2 &> /dev/null

echo "[Copying files...]"

mount "$1"1 /mnt
cp $2 /mnt/MLO
cp $3 /mnt/u-boot.bin
cp $4 /mnt/uImage
umount "$1"1

mount "$1"2 /mnt
tar zxvf $5 -C /mnt &> /dev/null
chmod 755 /mnt
umount "$1"2

echo "[Done]"
