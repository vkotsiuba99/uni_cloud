.PHONY: init apply cluster ip destroy

init:
	terraform init

apply:
	terraform apply -auto-approve

cluster:
	chmod +x scripts/orchestrate_cluster.sh
	./scripts/orchestrate_cluster.sh

ip:
	terraform output -raw load_balancer_public_ip

destroy:
	terraform destroy -auto-approve
