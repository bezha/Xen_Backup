#!/bin/bash

/root/backup-xen/xen-lvm-backup.sh > /dev/null 2>&1 && /root/backup-xen/backup2.sh | mailx -s "Backup XEN" bezhav@gmail.com