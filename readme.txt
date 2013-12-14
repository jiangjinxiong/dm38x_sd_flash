---------------------制作SD卡启动烧写说明及注意事项----------------------------------
【步骤一】：插入SD卡。
一般情况下linux自动挂载该设备，设备名称一般为： /dev/sdb。
<注意事项>
若linux不能识别SD卡，分别进行以下处理：
1、windows系统下格式化SD卡；
2、重启linux系统，再插入SD卡；
3、若SD卡制作过程中出现错误，有时候需要在linux下格式化SD卡,命令： sudo fdisk /dev/sdb。

【步骤二】：修改配置文件dm38x_sd.config。
export DM38x_UBOOT1=original/nand/u-boot.min.nand
export DM38x_UBOOT2=original/nand/u-boot.bin
export DM38x_KERNEL=original/nand/uImage_dm38x
export DM38x_ROOTFS=original/nand/ubifs_ipnc_full_feature.bin
#export DM38x_ROOTFS=/home/jiangjx/UbuntuShare/dm8127/filesys
################################################################################
#sd
export DM38x_UBOOT1_sd=original/sd/MLO
export DM38x_UBOOT2_sd=original/sd/u-boot.bin

说明：
nand目录下的u-boot.min.nand 文件采用 dm385_ipnc_min_nand 配置文件编译得到；
nand目录下的u-boot.bin      文件采用 dm385_ipnc_config_nand 配置文件编译得到；
sd目录下的u-boot.min.nand 文件采用 dm385_ipnc_min_sd 配置文件编译得到；
sd目录下的u-boot.bin      文件采用 dm385_ipnc_config_sd 配置文件编译得到；

【步骤三】：制作SD卡。
sudo ./mksdboot.sh --device /dev/sdb


