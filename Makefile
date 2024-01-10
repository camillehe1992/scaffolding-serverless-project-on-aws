#########################################################################
# Terraform Makefile
#########################################################################
-include .env

SHELL := /bin/bash
BASE := $(shell /bin/pwd)
MAKE ?= make

ifdef AWS_PROFILE
AWS_PROFILE := $(AWS_PROFILE)
else
AWS_PROFILE := default
endif

# The deployment name, shared or app
TF_ROOT_PATH := $(BASE)/terraform/deployment/todo_api
TF_VAR_FILE := $(BASE)/terraform/settings/$(ENVIRONMENT)/variables.tfvars

$(info AWS_ACCOUNT 		= $(AWS_ACCOUNT))
$(info AWS_PROFILE 		= $(AWS_PROFILE))
$(info AWS_REGION  		= $(AWS_REGION))
$(info ENVIRONMENT 		= $(ENVIRONMENT))
$(info NICKNAME    		= $(NICKNAME))
$(info STATE_BUCKET		= $(STATE_BUCKET))
$(info TF_ROOT_PATH 	= $(TF_ROOT_PATH))
$(info TF_VAR_FILE 		= $(TF_VAR_FILE))

# Add defaults/common variables for all components
define DEFAULTS
-var-file=$(TF_VAR_FILE) \
-var aws_profile=$(AWS_PROFILE) \
-var aws_region=$(AWS_REGION) \
-var environment=$(ENVIRONMENT) \
-var nickname=$(NICKNAME) \
-var state_bucket=$(STATE_BUCKET) \
-refresh=true -out tfplan
endef

OPTIONS += $(DEFAULTS)

$(info OPTIONS 		= $(OPTIONS))

#########################################################################
# Convenience Functions to use in Make
#########################################################################
environments := dev prod
check-for-environment = $(if $(filter $(ENVIRONMENT),$(environments)),,$(error Invalid environment: $(ENVIRONMENT). Accepted environments: $(environments)))

#########################################################################
# CICD Make Targets
#########################################################################
lint:
	$(info [*] Linting terraform)
	@$(TF) fmt -check -diff -recursive
	@$(TF) validate

pre-check:
	$(info [*] Check Environment Done)
	@$(call check-for-environment)
	@$(info $(shell aws sts get-caller-identity --profile $(AWS_PROFILE)))

init: pre-check
	$(info [*] Init Terrafrom Infra)
	@cd $(TF_ROOT_PATH) && terraform init -reconfigure \
		-backend-config="bucket=$(STATE_BUCKET)" \
		-backend-config="region=$(AWS_REGION)" \
		-backend-config="profile=$(AWS_PROFILE)" \
		-backend-config="key=$(NICKNAME)/$(ENVIRONMENT)/$(AWS_REGION)/$(DEPLOYMENT).tfstate"

plan: init
	$(info [*] Plan Terrafrom Infra)
	@cd $(TF_ROOT_PATH) && terraform plan $(OPTIONS)

plan-destroy: init
	$(info [*] Plan Terrafrom Infra - Destroy)
	@cd $(TF_ROOT_PATH) && terraform plan -destroy $(OPTIONS)

apply:
	$(info [*] Apply Terrafrom Infra)
	@cd $(TF_ROOT_PATH) && terraform apply tfplan

#########################################################################
# TEST Make Targets
#########################################################################
test-unit:
	$(info [*] Run unit test)
	python -m pytest ./tests/unit

test-e2e:
	$(info [*] Run e2e test)
	python -m pytest ./tests/e2e

test:
	$(info [*] Run all tests)
	$(MAKE) test-unit
	$(MAKE) test-e2e

#########################################################################
# Quick Deployment Make Targets
#########################################################################
deploy-infra:
	$(MAKE) DEPLOYMENT=common_infra plan-destroy
	$(MAKE) DEPLOYMENT=common_infra apply
