#!/bin/bash
apt-get update
apt-get install -y glusterfs-client

mkdir -p /mnt/gluster_data

# Add entry to fstab. We use the internal IP address of stor1 passed via Terraform
echo "${stor1_ip}:/vol0 /mnt/gluster_data glusterfs defaults,_netdev 0 0" >> /etc/fstab

# Give the system time for the GlusterFS cluster to be initialized by the neighboring script
# (Mounting will succeed after running the `make cluster` command)
