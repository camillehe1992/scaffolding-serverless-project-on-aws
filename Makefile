BASE := $(shell /bin/pwd)
PIPENV ?= pipenv
COMPONENT ?= ''

target:
	$(info ${HELP_MESSAGE})
	@exit 0

clean:
	$(info [*] Who needs all that anyway? Destroying environment....)
	rm -rf ./build/

install:
	$(info [*] Installing pipenv)
	@pip3 install pipenv --upgrade
	@$(PIPENV) shell

dev:
	$(info [*] Installing pipenv project dependencies)
	@$(PIPENV) install --dev
	@$(PIPENV) graph

lint:
	$(info [*] Linting terraform and python code)
	@terraform fmt -check -diff -recursive ./terraform
	@terraform validate
	@pylint --recursive=y ./src

package:
	$(info [*] Installing Lambda dependencies & Create .zip file archives)
	$(MAKE) clean
	docker run --rm \
		-v "${BASE}":/var/task \
		"public.ecr.aws/sam/build-python3.9" /bin/sh -c "./scripts/package.sh"

#################################### DEPLOY #####################################

deploy.infra:
	$(info [*] Deploy terraform deployment - common_infra)
	sh ./scripts/apply.sh common_infra

deploy.layers:
	$(info [*] Deploy terraform deployment - lambda_layers)
	$(MAKE) package
	sh ./scripts/apply.sh lambda_layers

deploy.layers.quick:
	$(info [*] Quick deploy terraform deployment - lambda_layers)
	sh ./scripts/apply.sh lambda_layers

deploy.frontend:
	$(info [*] Deploy terraform deployment - frontend)
	sh ./scripts/apply.sh frontend

deploy.backend:
	$(info [*] Deploy terraform deployment - backend)
	sh ./scripts/apply.sh backend

ci: ##=> Run full workflow - Install deps, package, and deploy
	$(MAKE) deploy.infra
	@sleep 10
	$(MAKE) deploy.layers
	@sleep 10
	$(MAKE) deploy.frontend
	@sleep 10
	$(MAKE) deploy.backend

#################################### DESTROY #####################################
destroy.infra:
	$(info [*] Destroy terraform deployment - common_infra)
	sh ./scripts/apply.sh common_infra destroy

destroy.layers:
	$(info [*] Destroy terraform deployment - lambda_layers)
	sh ./scripts/apply.sh lambda_layers destroy

destroy.frontend:
	$(info [*] Destroy terraform deployment - frontend)
	sh ./scripts/apply.sh frontend destroy

destroy.backend:
	$(info [*] Destroy terraform deployment - backend)
	sh ./scripts/apply.sh backend destroy

destroy.all:
	$(info [*] Destroy all terraform deployments in order)
	$(MAKE) destroy.backend
	$(MAKE) destroy.frontend
	$(MAKE) destroy.layers
	$(MAKE) destroy.infra

#################################### TEST #####################################
test:
	$(info [*] Not implemented yet)
