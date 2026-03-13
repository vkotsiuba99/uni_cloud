.PHONY: init apply cluster ip destroy

PROJECT_ID ?= your-gcp-project-id

init:
	terraform init

apply:
	terraform apply -var="project_id=$(PROJECT_ID)" -auto-approve

cluster:
	chmod +x scripts/orchestrate_cluster.sh
	./scripts/orchestrate_cluster.sh

ip:
	terraform output -raw load_balancer_public_ip

destroy:
	terraform destroy -var="project_id=$(PROJECT_ID)" -auto-approve
