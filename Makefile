.PHONY: init-dev plan-dev apply-dev destroy-dev \
        init-prod plan-prod apply-prod destroy-prod \
        fmt validate-dev validate-prod

init-dev:
	terraform -chdir=envs/dev init

plan-dev:
	terraform -chdir=envs/dev plan

apply-dev:
	terraform -chdir=envs/dev apply

destroy-dev:
	terraform -chdir=envs/dev destroy

init-prod:
	terraform -chdir=envs/prod init

plan-prod:
	terraform -chdir=envs/prod plan

apply-prod:
	terraform -chdir=envs/prod apply

destroy-prod:
	terraform -chdir=envs/prod destroy

fmt:
	terraform fmt -recursive

validate-dev:
	terraform -chdir=envs/dev validate

validate-prod:
	terraform -chdir=envs/prod validate
