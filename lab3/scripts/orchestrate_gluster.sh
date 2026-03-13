#!/bin/bash
set -e

RESOURCE_GROUP="uni-cloud-lab3-rg"

STOR1_IP=$(terraform output -raw stor1_internal_ip)
STOR2_IP=$(terraform output -raw stor2_internal_ip)

echo "=== 1. Joining nodes (Peer Probe) via Azure CLI ==="
az vm run-command invoke \
  --resource-group "$RESOURCE_GROUP" \
  --name "vladyslav-kotsiuba-im52mp-stor1" \
  --command-id RunShellScript \
  --scripts "gluster peer probe $STOR2_IP"

sleep 5

echo "=== 2. Creating replicated GlusterFS volume (Replica 2) ==="
az vm run-command invoke \
  --resource-group "$RESOURCE_GROUP" \
  --name "vladyslav-kotsiuba-im52mp-stor1" \
  --command-id RunShellScript \
  --scripts "yes | gluster volume create vol0 replica 2 $STOR1_IP:/storage/gluster/vol0/brick $STOR2_IP:/storage/gluster/vol0/brick force"

echo "=== 3. Starting volume ==="
az vm run-command invoke \
  --resource-group "$RESOURCE_GROUP" \
  --name "vladyslav-kotsiuba-im52mp-stor1" \
  --command-id RunShellScript \
  --scripts "gluster volume start vol0"

echo "=== 4. Mounting on Client and writing test file ==="
az vm run-command invoke \
  --resource-group "$RESOURCE_GROUP" \
  --name "vladyslav-kotsiuba-im52mp-client" \
  --command-id RunShellScript \
  --scripts "mount -a && echo 'RAID1 + LVM + GlusterFS Success! Created by Vladyslav Kotsiuba IM-52mp' | tee /mnt/gluster_data/student_test.txt"

echo "Cluster created! Test file written."
