#!/bin/bash
apt-get update
# Install utilities without interactive prompts
DEBIAN_FRONTEND=noninteractive apt-get install -y mdadm lvm2 glusterfs-server xfsprogs

# 1. Create RAID 1 from two attached disks (/dev/sdb and /dev/sdc)
yes | mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc

# 2. Configure LVM on top of RAID
pvcreate /dev/md0
vgcreate newvg /dev/md0
lvcreate -n logvol1 -L 1G newvg
lvcreate -n glusterlv -l 100%FREE newvg

# 3. Format and mount
mkfs.ext4 /dev/newvg/logvol1
mkfs.ext4 /dev/newvg/glusterlv

mkdir -p /mnt/data1
mkdir -p /storage/gluster/vol0

mount /dev/newvg/logvol1 /mnt/data1
mount /dev/newvg/glusterlv /storage/gluster/vol0

# Write to fstab for automatic mounting after reboot
echo "/dev/newvg/logvol1 /mnt/data1 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/newvg/glusterlv /storage/gluster/vol0 ext4 defaults 0 0" >> /etc/fstab

# Create a "brick" directory for GlusterFS (best practice to avoid root-directory errors)
mkdir -p /storage/gluster/vol0/brick

# 4. Start GlusterFS
systemctl enable glusterd
systemctl start glusterd
