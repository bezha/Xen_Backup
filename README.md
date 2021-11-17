Backup Xen VPS

- [x] In file xen-lvm-backup.sh change XENLVM to proper VG name (pvs -a)
- [x] In file backup.sh change Xen name
- [x] Set up Cron job: 00 02 * * * /root/backup-xen/backup.sh

For disk partition please use parted: 

Manual https://www.jeffgeerling.com/blog/2021/htgwa-partition-format-and-mount-large-disk-linux-parted

- parted /dev/sda
- (parted) mklabel gpt             # to create a partition table
- (parted) print                   # to verify parition info
- (parted) mkpart primary 0% 100%  # create primary partition filling entire disk
- (parted) quit

For Xen installation need: https://docs.solusvm.com/Bridge%2Bconfiguration%2Bfor%2BXen%2BSlave.html

Disable Network Manager as it may interfere with the bridge.

- systemctl stop NetworkManager.service
- systemctl disable NetworkManager.service
- systemctl enable network.service
- systemctl start network.service

Change interface to eth0 https://www.thegeekdiary.com/centos-rhel-7-how-to-modify-network-interface-names/

- Edit file /etc/default/grub and add net.ifnames=0 biosdevname=0 to line GRUB_CMDLINE_LINUX, for instance:
- GRUB_CMDLINE_LINUX=" crashkernel=auto net.ifnames=0 biosdevname=0 rhgb quiet"

Regenerate a GRUB configuration file and overwrite existing one:
- grub2-mkconfig -o /boot/grub2/grub.cfg
- mv /etc/sysconfig/network-scripts/ifcfg-em1 /etc/sysconfig/network-scripts/ifcfg-eth0
- brctl show
