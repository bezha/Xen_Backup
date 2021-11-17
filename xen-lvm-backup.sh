#!/bin/bash

/usr/bin/rm -rf /root/backup-xen/xen-lvm-backup.cfg;
/usr/sbin/lvdisplay | /usr/bin/grep Name | /usr/bin/grep _img | /usr/bin/grep -v snap| /usr/bin/awk '{print $3}' > /root/backup-xen/xen-lvm-backup.cfg;

[ ! -f /root/backup-xen/xen-lvm-backup.cfg ] && { echo -e "\nConfig file not found, creating it\nPlease add your LVMs to the config file becore continuing\n"  && exit 1; };
[ ! -s /root/backup-xen/xen-lvm-backup.cfg ] && { echo -e "\nkvm-lvm-backup.cfg is empty, please fill in your LVM details" && exit 1; };

/usr/bin/mkdir -p /backup/`date "+%Y%m%d"`;
/usr/bin/rm -rf /backup/`date +%Y%m%d -d "7 day ago"`;

/usr/bin/echo "$(date)"
/usr/bin/cat /root/backup-xen/xen-lvm-backup.cfg | while read iName; do
if [ -z "${iName}" ]; then /usr/bin/echo -e "\nNo LVM Name or Volume Group Specified...Skipping\n"; continue; fi;
lv_path=$(/sbin/lvscan | /usr/bin/grep "`/usr/bin/echo XENLVM\/${iName}`" | /usr/bin/awk '{print $2}' | /usr/bin/tr -d "'");
if [ -z "${lv_path}" ]; then /usr/bin/echo -e "\nNo such LVM exists: ${lv_path}\nCorrect path name in config file\n"; continue; fi;
size=$(/sbin/lvs ${lv_path} -o LV_SIZE --noheadings --units g --nosuffix | /usr/bin/tr -d ' ');
/usr/sbin/lvcreate -s --size=${size}G -n ${iName}_snap ${lv_path} && /usr/bin/dd if=${lv_path}_snap bs=16MB | /usr/bin/gzip -c | /usr/bin/dd of=/backup/`date "+%Y%m%d"`/XENLVM-${iName}.`date +%Y-%m-%d-%H`.gz > /dev/null 2>&1;
/usr/sbin/lvremove -f ${lv_path}_snap;
/usr/bin/echo "$(date)"
done;
