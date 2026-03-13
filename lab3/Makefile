.PHONY: init apply cluster verify destroy

init:
	terraform init

apply:
	terraform apply -auto-approve

cluster:
	chmod +x scripts/orchestrate_gluster.sh
	./scripts/orchestrate_gluster.sh

verify:
	@echo "Checking RAID status on stor1:"
	az vm run-command invoke --resource-group uni-cloud-lab3-rg --name vladyslav-kotsiuba-im52mp-stor1 --command-id RunShellScript --scripts "mdadm --detail /dev/md0"
	@echo "\nChecking LVM on stor1:"
	az vm run-command invoke --resource-group uni-cloud-lab3-rg --name vladyslav-kotsiuba-im52mp-stor1 --command-id RunShellScript --scripts "lvdisplay newvg"
	@echo "\nChecking GlusterFS volume status:"
	az vm run-command invoke --resource-group uni-cloud-lab3-rg --name vladyslav-kotsiuba-im52mp-stor1 --command-id RunShellScript --scripts "gluster volume status"
	@echo "\nReading test file from Client Node:"
	az vm run-command invoke --resource-group uni-cloud-lab3-rg --name vladyslav-kotsiuba-im52mp-client --command-id RunShellScript --scripts "cat /mnt/gluster_data/student_test.txt"

destroy:
	terraform destroy -auto-approve
