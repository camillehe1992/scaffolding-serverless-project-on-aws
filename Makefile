BASE := $(shell /bin/pwd)

TF ?= terraform
PIP ?= pip
COMPONENT ?= ''

target:
	$(info ${HELP_MESSAGE})
	@exit 0

clean:
	$(info [*] Who needs all that anyway? Destroying environment....)
	rm -rf ./build/

install:
	$(info [*] Enable Git Hooks & Installing project dependencies)
	pre-commit install
	@$(PIP) install -r requirements-dev.txt

lint:
	$(info [*] Linting terraform and python code)
	@$(TF) fmt -check -diff -recursive ./terraform
	@$(TF) validate
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
	sh ./scripts/deploy.sh common_infra

deploy.layers:
	$(info [*] Deploy terraform deployment - lambda_layers)
	$(MAKE) package
	sh ./scripts/deploy.sh lambda_layers

deploy.layers.quick:
	$(info [*] Quick deploy terraform deployment - lambda_layers)
	sh ./scripts/apply.sh lambda_layers

deploy.frontend:
	$(info [*] Deploy terraform deployment - frontend)
	sh ./scripts/apply.sh frontend

ci: ##=> Run full workflow - Install deps, package, and deploy
	$(MAKE) deploy.infra
	@sleep 10
	$(MAKE) deploy.layers
	@sleep 10
	$(MAKE) deploy.frontend

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

destroy.all:
	$(info [*] Destroy all terraform deployments in order)
	$(MAKE) destroy.backend
	$(MAKE) destroy.frontend
	$(MAKE) destroy.layers
	$(MAKE) destroy.infra

#################################### TEST #####################################
test.unit:
	$(info [*] Run unit test)
	python -m pytest ./tests/unit

test.e2e:
	$(info [*] Run e2e test)
	python -m pytest ./tests/e2e

test:
	$(info [*] Run all tests)
	$(MAKE) test.unit
	$(MAKE) test.e2e