#!/bin/sh
set -x

apt install nfs-common -y

export SERVER_HOST="192.168.2.160"
mount -a   #让文件/etc/fstab生效

df -Th

cat >> /etc/fstab << EOF
$SERVER_HOST:/public/data  /mnt/public       nfs    defaults 0 0
EOF

# 用来察看 NFS 分享出来的目录资源
showmount -e 192.168.2.152

set +x

我使用了
sudo gdisk /dev/vdb
sudo mkfs.ext4 /dev/sdb1
sudo mount /dev/sdb1 /

