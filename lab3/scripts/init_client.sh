#!/bin/bash
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do sleep 5; done
while fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 5; done

apt-get update
apt-get install -y glusterfs-client

mkdir -p /mnt/gluster_data

# Add entry to fstab. We use the internal IP address of stor1 passed via Terraform
echo "${stor1_ip}:/vol0 /mnt/gluster_data glusterfs defaults,_netdev 0 0" >> /etc/fstab

# Give the system time for the GlusterFS cluster to be initialized by the neighboring script
# (Mounting will succeed after running the `make cluster` command)
