 lvremove /dev/vg_root/lv_root
 vgremove /dev/vg_root
 pvremove /dev/sdb
 lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
 mkfs.xfs /dev/VolGroup00/LogVol_Home
 mount /dev/VolGroup00/LogVol_Home /mnt/
 cp -aR /home/* /mnt/
 rm -rf /home/*
 umount /mnt
 mount /dev/VolGroup00/LogVol_Home /home/
 echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab


