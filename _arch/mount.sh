#!/bin/bash
/bin/mount -t ntfs-3g UUID=F88644218643DEAE /mnt/nvme1n1p1 -o uid=000,gid=1002
/bin/mount -t cifs //ubuntu22/sda2 /mnt/sda2 -o uid=000,gid=1000,credentials=/home/scillidan/Usr/Git/Data/srv/smb_credentials,file_mode=0664,dir_mode=0775,_netdev
