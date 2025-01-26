#########################################################################
# Terraform Makefile
#########################################################################
-include .env

SHELL := /bin/bash
BASE := $(shell /bin/pwd)
MAKE ?= make

APP_VERSION := $(shell cat VERSION.txt)
DEPLOYMENT := api
ENVIRONMENT := dev
NICKNAME := sls-template

ifdef AWS_PROFILE
AWS_PROFILE := $(AWS_PROFILE)
else
AWS_PROFILE := default
endif

# The deployment name, shared or app
TF_ROOT_PATH := $(BASE)/terraform/deployments/$(DEPLOYMENT)
TF_VAR_FILE := $(BASE)/terraform/settings/$(ENVIRONMENT)/terraform.tfvars

$(info APP_VERSION 		= $(APP_VERSION))
$(info AWS_PROFILE 		= $(AWS_PROFILE))
$(info AWS_REGION  		= $(AWS_REGION))
$(info ENVIRONMENT 		= $(ENVIRONMENT))
$(info NICKNAME    		= $(NICKNAME))
$(info DEPLOYMENT    	= $(DEPLOYMENT))
$(info STATE_BUCKET		= $(STATE_BUCKET))
$(info TF_ROOT_PATH 	= $(TF_ROOT_PATH))
$(info TF_VAR_FILE 		= $(TF_VAR_FILE))

# Add deployment specific variables
define API_OPTIONS
-var app_version=${APP_VERSION}
endef

ifeq ($(DEPLOYMENT), api)
override OPTIONS += $(API_OPTIONS)
endif

# Add defaults/common variables for all components
define DEFAULTS
-var-file=$(TF_VAR_FILE) \
-var aws_profile=$(AWS_PROFILE) \
-var aws_region=$(AWS_REGION) \
-var environment=$(ENVIRONMENT) \
-var nickname=$(NICKNAME) \
-refresh=true -out tfplan
endef

override OPTIONS += $(DEFAULTS)

#########################################################################
# Convenience Functions to use in Make
#########################################################################
environments := dev
check-for-environment = $(if $(filter $(ENVIRONMENT),$(environments)),,$(error Invalid environment: $(ENVIRONMENT). Accepted environments: $(environments)))
deployments := common_infra api dynamodb
check-for-deployment = $(if $(filter $(DEPLOYMENT),$(deployments)),,$(error Invalid deployment: $(DEPLOYMENT). Accepted deployments: $(deployments)))
#########################################################################
# CICD Make Targets
#########################################################################
lint:
	$(info [*] Linting terraform & python source code)
	terraform fmt -check -diff -recursive
	terraform validate
	pylint src/*

pre-check:
	$(info [*] Check Environment Done)
	@$(call check-for-environment)
	@$(call check-for-deployment)
	@$(info $(shell aws sts get-caller-identity --profile $(AWS_PROFILE)))

init: pre-check
	$(info [*] Init Terrafrom Infra)
	@cd $(TF_ROOT_PATH) && terraform init -reconfigure -upgrade \
		-backend-config="bucket=$(STATE_BUCKET)" \
		-backend-config="region=$(AWS_REGION)" \
		-backend-config="profile=$(AWS_PROFILE)" \
		-backend-config="key=$(NICKNAME)/$(ENVIRONMENT)/$(AWS_REGION)/$(DEPLOYMENT).tfstate" \
		-backend-config="encrypt=true"

plan: init
	$(info [*] Plan Terrafrom Infra)
	@cd $(TF_ROOT_PATH) && terraform plan $(OPTIONS)

destroy: init
	$(info [*] Plan Terrafrom Infra - Destroy)
	@cd $(TF_ROOT_PATH) && terraform plan -destroy $(OPTIONS)

apply:
	$(info [*] Apply Terrafrom Infra)
	@cd $(TF_ROOT_PATH) && terraform apply tfplan

plan-apply: init
	@cd $(TF_ROOT_PATH) && terraform plan $(OPTIONS) && terraform apply tfplan


destroy-apply: init
	@cd $(TF_ROOT_PATH) && terraform plan -destroy $(OPTIONS) && terraform apply tfplan

deploy-all:
	$(info [*] Deploy All Infra to Dev)
	@MAKE DEPLOYMENT=common_infra plan-apply
	@MAKE DEPLOYMENT=dynamodb plan-apply
	@MAKE DEPLOYMENT=api plan-apply

destroy-all:
	$(info [*] Destroy All Infra to Dev)
	@MAKE DEPLOYMENT=api destroy-apply
	@MAKE DEPLOYMENT=common_infra destroy-apply
	@MAKE DEPLOYMENT=dynamodb destroy-apply

#########################################################################
# TEST Make Targets
#########################################################################
unit-test:
	$(info [*] Run unit test with coverage report)
	coverage run -m pytest
	coverage report -m

e2e-test:
	$(info [*] Test RestAPIs via invoking API Gateway endpoint)
	python -m pytest ./src/tests/e2e/

local-test:
	$(info [*] Run local test)
	python -m src.tests.local.run
