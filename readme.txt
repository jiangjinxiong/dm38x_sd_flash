---------------------����SD��������д˵����ע������----------------------------------
������һ��������SD����
һ�������linux�Զ����ظ��豸���豸����һ��Ϊ�� /dev/sdb��
<ע������>
��linux����ʶ��SD�����ֱ�������´���
1��windowsϵͳ�¸�ʽ��SD����
2������linuxϵͳ���ٲ���SD����
3����SD�����������г��ִ�����ʱ����Ҫ��linux�¸�ʽ��SD��,��� sudo fdisk /dev/sdb��

������������޸������ļ�dm38x_sd.config��
export DM38x_UBOOT1=original/nand/u-boot.min.nand
export DM38x_UBOOT2=original/nand/u-boot.bin
export DM38x_KERNEL=original/nand/uImage_dm38x
export DM38x_ROOTFS=original/nand/ubifs_ipnc_full_feature.bin
#export DM38x_ROOTFS=/home/jiangjx/UbuntuShare/dm8127/filesys
################################################################################
#sd
export DM38x_UBOOT1_sd=original/sd/MLO
export DM38x_UBOOT2_sd=original/sd/u-boot.bin

˵����
nandĿ¼�µ�u-boot.min.nand �ļ����� dm385_ipnc_min_nand �����ļ�����õ���
nandĿ¼�µ�u-boot.bin      �ļ����� dm385_ipnc_config_nand �����ļ�����õ���
sdĿ¼�µ�u-boot.min.nand �ļ����� dm385_ipnc_min_sd �����ļ�����õ���
sdĿ¼�µ�u-boot.bin      �ļ����� dm385_ipnc_config_sd �����ļ�����õ���

����������������SD����
sudo ./mksdboot.sh --device /dev/sdb


