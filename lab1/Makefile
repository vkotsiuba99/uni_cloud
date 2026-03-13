.PHONY: init apply destroy ip

init:
	terraform init

apply:
	terraform apply -auto-approve

ip:
	terraform output -raw load_balancer_public_ip

destroy:
	terraform destroy -auto-approve
