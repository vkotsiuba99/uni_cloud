#!/bin/bash
ZONE="us-central1-a"

STOR1_IP=$(terraform output -raw stor1_internal_ip)
STOR2_IP=$(terraform output -raw stor2_internal_ip)

echo "=== 1. Trying to join nodes (Peer Probe) ==="
gcloud compute ssh vladyslav-kotsiuba-im52mp-stor1 --zone=$ZONE --command="sudo gluster peer probe $STOR2_IP"
sleep 5 # Waiting for synchronization

echo "=== 2. Creating replicated GlusterFS volume (Replica 2) ==="
# Using force because we create in the same subnet
gcloud compute ssh vladyslav-kotsiuba-im52mp-stor1 --zone=$ZONE --command="yes | sudo gluster volume create vol0 replica 2 $STOR1_IP:/storage/gluster/vol0/brick $STOR2_IP:/storage/gluster/vol0/brick force"
echo "=== 3. Starting volume ==="
gcloud compute ssh vladyslav-kotsiuba-im52mp-stor1 --zone=$ZONE --command="sudo gluster volume start vol0"
echo "=== 4. Mounting on Client and writing test file ==="
gcloud compute ssh vladyslav-kotsiuba-im52mp-client --zone=$ZONE --command="sudo mount -a && echo 'RAID1 + LVM + GlusterFS Success! Created by Vladyslav Kotsiuba IM-52mp' | sudo tee /mnt/gluster_data/student_test.txt"
echo "Cluster created! Test file written."
