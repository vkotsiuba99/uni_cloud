#!/bin/bash
set -e

DB_PASS="TestUs3r4!DB"
RESOURCE_GROUP="uni-cloud-lab2-rg"

DB1=$(terraform output -raw db1_internal_ip)
DB2=$(terraform output -raw db2_internal_ip)
DB3=$(terraform output -raw db3_internal_ip)

echo "=== 1. Configuring MySQL Instances for Group Replication (via Azure CLI) ==="
for i in 1 2 3; do
  az vm run-command invoke \
    --resource-group "$RESOURCE_GROUP" \
    --name "vladyslav-kotsiuba-im52mp-db$i" \
    --command-id RunShellScript \
    --scripts "mysqlsh --user=root --password=$DB_PASS --host=localhost --dba configure-instance --interactive=false --clusterAdmin=clusteradmin --clusterAdminPassword=$DB_PASS --restart=true"
done

echo "=== 2. Creating InnoDB Cluster on Primary Node ==="
az vm run-command invoke \
  --resource-group "$RESOURCE_GROUP" \
  --name "vladyslav-kotsiuba-im52mp-db1" \
  --command-id RunShellScript \
  --scripts "mysqlsh --user=clusteradmin --password=$DB_PASS --host=localhost --dba create-cluster testCluster --interactive=false"

echo "=== 3. Adding Replicas to Cluster ==="
az vm run-command invoke \
  --resource-group "$RESOURCE_GROUP" \
  --name "vladyslav-kotsiuba-im52mp-db1" \
  --command-id RunShellScript \
  --scripts "mysqlsh --user=clusteradmin --password=$DB_PASS --host=localhost --cluster testCluster --dba add-instance clusteradmin@$DB2:3306 --interactive=false --password=$DB_PASS --recoveryMethod=clone"

az vm run-command invoke \
  --resource-group "$RESOURCE_GROUP" \
  --name "vladyslav-kotsiuba-im52mp-db1" \
  --command-id RunShellScript \
  --scripts "mysqlsh --user=clusteradmin --password=$DB_PASS --host=localhost --cluster testCluster --dba add-instance clusteradmin@$DB3:3306 --interactive=false --password=$DB_PASS --recoveryMethod=clone"

echo "=== 4. Bootstrapping MySQL Router on Web Nodes ==="
for i in 1 2; do
  az vm run-command invoke \
    --resource-group "$RESOURCE_GROUP" \
    --name "vladyslav-kotsiuba-im52mp-web$i" \
    --command-id RunShellScript \
    --scripts "mysqlrouter --bootstrap clusteradmin@$DB1:3306 --user=mysqlrouter --conf-base=/etc/mysqlrouter --force && systemctl restart mysqlrouter"
done

echo "=== Cluster Initialization Complete! ==="
