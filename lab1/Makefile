.PHONY: init apply destroy ip

PROJECT_ID ?= your-gcp-project-id # You can change it here or pass it when running make

init:
	terraform init

apply:
	terraform apply -var="project_id=$(PROJECT_ID)" -auto-approve

ip:
	terraform output -raw load_balancer_public_ip

destroy:
	terraform destroy -var="project_id=$(PROJECT_ID)" -auto-approve
