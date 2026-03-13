.PHONY: init apply cluster verify destroy

PROJECT_ID ?= your-gcp-project-id

init:
	terraform init

apply:
	terraform apply -var="project_id=$(PROJECT_ID)" -auto-approve

cluster:
	chmod +x scripts/orchestrate_gluster.sh
	./scripts/orchestrate_gluster.sh

verify:
	@echo "Checking RAID status on stor1:"
	gcloud compute ssh vladyslav-kotsiuba-im52mp-stor1 --zone=us-central1-a --command="sudo mdadm --detail /dev/md0"
	@echo "\nChecking LVM on stor1:"
	gcloud compute ssh vladyslav-kotsiuba-im52mp-stor1 --zone=us-central1-a --command="sudo lvdisplay newvg"
	@echo "\nChecking GlusterFS volume status:"
	gcloud compute ssh vladyslav-kotsiuba-im52mp-stor1 --zone=us-central1-a --command="sudo gluster volume status"
	@echo "\nReading test file from Client Node:"
	gcloud compute ssh vladyslav-kotsiuba-im52mp-client --zone=us-central1-a --command="cat /mnt/gluster_data/student_test.txt"

destroy:
	terraform destroy -var="project_id=$(PROJECT_ID)" -auto-approve
