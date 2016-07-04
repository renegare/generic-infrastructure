################################################################################
# In order to use the task here you need to have the following
# environment variables exposed:
# * AWS_ACCESS_KEY_ID
# * AWS_SECRET_ACCESS_KEY
# * AWS_DEFAULT_REGION
# * ENV
# * PROJECT
################################################################################

BRANCH=$(shell git symbolic-ref --short HEAD)
VERSION=$(BRANCH)-$(shell git rev-parse HEAD)
TF_REMOTE_BUCKET=tf-infra-state
TF_DIR=./tf

_check_env:
	@if [ -z $${$(_ENVKEY_)+x} ]; then echo "Failure: $(_ENVKEY_) env var has not been set." && exit 1; fi

check:
	@$(MAKE) _ENVKEY_=AWS_ACCESS_KEY_ID _check_env
	@$(MAKE) _ENVKEY_=AWS_SECRET_ACCESS_KEY _check_env
	@$(MAKE) _ENVKEY_=AWS_DEFAULT_REGION _check_env
	@$(MAKE) _ENVKEY_=PROJECT _check_env
	@$(MAKE) _ENVKEY_=ENV _check_env
	@echo 'Environment variables check successful'

sync: check
	@if [ -z $${PROJECT+x} ]; then echo "Failure: PROJECT var has not been set." && exit 1; fi
	rm -rf ./.terraform
	terraform remote config \
		-backend=s3 \
		-backend-config="bucket=$(TF_REMOTE_BUCKET)" \
		-backend-config="key=$(PROJECT)-$(ENV).tfstate" \
		-backend-config="region=$(AWS_DEFAULT_REGION)"
	terraform remote pull

plan:
	CMD=$@ $(MAKE) exec

exec: sync
	@terraform $(CMD) \
		-var 'access_key=$(AWS_ACCESS_KEY_ID)' \
		-var 'access_secret=$(AWS_SECRET_ACCESS_KEY)' \
		-var 'region=$(AWS_DEFAULT_REGION)' \
		-var 'project=$(PROJECT_NAME)' \
		-var 'environment=$(ENV)' \
		-var 'infra_state_bucket=$(TF_REMOTE_BUCKET)' \
		-var 'version=$(VERSION)' \
		$(TF_DIR)

apply:
	CMD=$@ $(MAKE) exec

destroy:
	CMD=$@ $(MAKE) exec

graph:
	terraform graph $(TF_DIR) | dot -Tpng > graph.png

pull: check
	terraform remote pull

push: check
	terraform remote push

gen-ssh-keypair:
	-rm -f ec2_rsa*
	ssh-keygen -t rsa -N "" -f ./ec2_rsa

db-tunnel:
	ssh -i ./ec2_rsa -L 3306:$(shell terraform output db_host):3306 ec2-user@$(shell terraform output bastion)
