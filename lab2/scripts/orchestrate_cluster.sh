#!/bin/bash
DB_PASS="TestUs3r4!DB"
ZONE="us-central1-a"

DB1=$(terraform output -raw db1_internal_ip)
DB2=$(terraform output -raw db2_internal_ip)
DB3=$(terraform output -raw db3_internal_ip)

echo "=== 1. Configuring MySQL Instances for Group Replication ==="
for i in 1 2 3; do
  gcloud compute ssh vladyslav-kotsiuba-im52mp-db$i --zone=$ZONE --command="sudo mysqlsh --user=root --password=$DB_PASS --host=localhost --dba configure-instance --interactive=false --clusterAdmin=clusteradmin --clusterAdminPassword=$DB_PASS --restart=true"
done

echo "=== 2. Creating InnoDB Cluster on Primary Node ==="
gcloud compute ssh vladyslav-kotsiuba-im52mp-db1 --zone=$ZONE --command="sudo mysqlsh --user=clusteradmin --password=$DB_PASS --host=localhost --dba create-cluster testCluster --interactive=false"

echo "=== 3. Adding Replicas to Cluster ==="
gcloud compute ssh vladyslav-kotsiuba-im52mp-db1 --zone=$ZONE --command="sudo mysqlsh --user=clusteradmin --password=$DB_PASS --host=localhost --cluster testCluster --dba add-instance clusteradmin@$DB2:3306 --interactive=false --password=$DB_PASS --recoveryMethod=clone"

gcloud compute ssh vladyslav-kotsiuba-im52mp-db1 --zone=$ZONE --command="sudo mysqlsh --user=clusteradmin --password=$DB_PASS --host=localhost --cluster testCluster --dba add-instance clusteradmin@$DB3:3306 --interactive=false --password=$DB_PASS --recoveryMethod=clone"

echo "=== 4. Bootstrapping MySQL Router on Web Nodes ==="
for i in 1 2; do
  gcloud compute ssh vladyslav-kotsiuba-im52mp-web$i --zone=$ZONE --command="sudo mysqlrouter --bootstrap clusteradmin@$DB1:3306 --user=mysqlrouter --conf-base=/etc/mysqlrouter --force && sudo systemctl restart mysqlrouter"
done

echo "=== Cluster Initialization Complete! ==="
