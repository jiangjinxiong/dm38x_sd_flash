#! /bin/sh
# Script to create SD card for DM38x plaform.
#
# Author: jiangjinxiong
#

VERSION="1.00"

source ./dm38x_sd.config

execute ()
{
  $* > /dev/null
  if [ $? -ne 0 ]; then
    echo
    echo "ERROR: executing $*"
    echo
    exit 1
  fi
}

version ()
{
  echo
  echo "`basename $1` version $VERSION"
  echo "Script to create bootable SD card for DM38x IPNC"
  echo
  exit 0
}

usage ()
{
  echo "
Usage: `basename $1` [options] <device>

Mandatory options:
  --device              SD block device node (e.g /dev/sdb)

Optional options:
  --version             Print version.
  --help                Print this help message.
"
  exit 1
}

# Process command line...
while [ $# -gt 0 ]; do
  case $1 in
    --help | -h) usage $0;;
    --version | -v) version $0;;
    --device  | -d) shift; device=$1; shift; ;;
    *) copy="$copy $1"; shift;;
  esac
done

test -z $device && usage $0

#if [ ! -d $filesysdir ]; then
#   echo "ERROR: $filesysdir does not exist,failed to find rootfs"
#   exit 1;
#fi
 
if [ ! -b $device ]; then
  echo "ERROR: $device is not a block device file"
  exit 1;
fi

echo "************************************************************"
echo "*         THIS WILL DELETE ALL THE DATA ON $device        *"
echo "*                                                          *"
echo "*         WARNING! Make sure your computer does not go     *"
echo "*                  in to idle mode while this script is    *"
echo "*                  running. The script will complete,      *"
echo "*                  but your SD card may be corrupted.      *"
echo "*                                                          *"
echo "*         Press <ENTER> to confirm....                     *"
echo "************************************************************"
read junk

for i in `ls -1 $device?`; do
  echo "unmounting device '$i'"
  umount $i 2>/dev/null
done

#echo "All data on "$1" now will be destroyed! Continue? [y/n]"
#read ans
#if ! [ $ans == 'y' ]; then
#  exit 1;
#fi

DRIVE=$device
echo "[Partitioning $DRIVE...]"

dd if=/dev/zero of=$DRIVE bs=1024 count=1024
	 
SIZE=`fdisk -l $DRIVE | grep Disk | awk '{print $5}'`
	 
echo DISK SIZE - $SIZE bytes
 
CYLINDERS=`echo $SIZE/255/63/512 | bc`

pc1_start=0
pc1_end=$((($CYLINDERS - $pc1_start) / 100 *99 ))

# start of rootfs partition
pc2_start=$(($pc1_start + $pc1_end))

echo CYLINDERS - $CYLINDERS
{
#  echo $pc1_start,$pc1_end,0x0C,*
#  echo $pc2_start,$pc2_end,,-
echo ,9,0x0C,*
echo 10,,,-
} | sfdisk -D -H 255 -S 63 -C $CYLINDERS $DRIVE

echo "[Making filesystems...]"

mkfs.vfat -F 32 -n boot ${DRIVE}1 &> /dev/null
#mkfs.ext3 -L rootfs ${device}2 &> /dev/null
mkfs.vfat -F 32 -n rootfs ${DRIVE}2 &> /dev/null

#echo "[Creating boot.scr...]"
#cat <<EOF >./original/sd/boot.scr
#EOF

echo "[Making ubifs image...]"
mkdir -p ./tmp
mkfs.ubifs -r $FILESYS_DM8127 -o ./tmp/ubifs.img -m 2048 -e 126976 -c 827
ubinize -o $DM38x_ROOTFS -m 2048 -p 128KiB -s 512 -O 2048 ./ubinize.cfg
rm -rf ./tmp

echo "[Copying files...]"

mount ${DRIVE}1 /mnt
if [ $? -eq 0 ]; then
  mkdir /mnt/nand
  cp $DM38x_UBOOT1 /mnt/nand/u-boot.min.nand
  cp $DM38x_UBOOT2 /mnt/nand/u-boot.bin
  cp $DM38x_KERNEL /mnt/nand/uImage
  cp $DM38x_ROOTFS /mnt/nand/rootfs

  cp $DM38x_UBOOT1_sd /mnt/MLO
  cp $DM38x_UBOOT2_sd /mnt/u-boot.bin
fi
umount ${DRIVE}1

#mount ${DRIVE}2 /mnt
#tar zxvf $5 -C /mnt &> /dev/null
#chmod 755 /mnt
#umount ${DRIVE}2

echo -e "\033[43;36m completed! \033[0m" 

