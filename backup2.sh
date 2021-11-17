/bin/echo "[ Disk Space Information ]"
/bin/df -h | /bin/grep backup;
/bin/echo
/bin/echo "[ LVM Space Information ]"
/sbin/pvs -a | /bin/grep lvm2;
/bin/echo
/bin/echo "[ All VPS ]"
/sbin/lvdisplay | /bin/grep Name | /bin/grep _img | grep -v img_snap | /bin/awk '{print $3}' | wc -l
/bin/echo
/bin/echo "[ Active VPS ]"
/usr/sbin/xl list | /bin/grep vm | wc -l
/bin/echo
/bin/echo "[ Backuped VPS ]"
/bin/ls -1 /backup/`date +%Y%m%d -d "1 day ago"` | wc -l
/bin/echo
/bin/echo "[ VPS Backup Information ]"
/usr/bin/du -sh /backup/2021*;
