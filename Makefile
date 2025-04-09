default: help

.PHONY: help fmt lint plan apply destroy
help: ## print targets and their descrptions
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

fmt: ## terraform fmt
	terraform fmt -recursive -write .

lint: ## vcl lint
	falco lint -I . -vv cdn/terraform/vcl/*.vcl
	falco fmt -w cdn/terraform/vcl/*.vcl

plan: ## terraform plan
	cd cdn/terraform && terraform plan --var-file=tls.tfvars

apply: ## terraform apply
	cd cdn/terraform && terraform apply --auto-approve --var-file=tls.tfvars

destroy: ## terraform destroy
	cd cdn/terraform && terraform destroy --var-file=tls.tfvars
