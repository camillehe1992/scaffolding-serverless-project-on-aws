# Deployment Documenatation

Deploy below AWS resources into target AWS account from local environment or using CICD pipelines.

| Deployment   | File                   | Terraform Modules        | Main AWS Resources                                                 |
| ------------ | ---------------------- | ------------------------ | ------------------------------------------------------------------ |
| common_infra | common_infra/roles.tf  | lambda_execution_role    | IAM Role                                                           |
| common_infra | common_infra/roles.tf  | api_gateway_logging_role | IAM Role                                                           |
| common_infra | common_infra/layers.tf | dependencies_layer       | Lambda Layer                                                       |
| api          | api/api_gateway.tf     | api_gateway              | API Gateway RestAPI, Stage, Deployment, CloudWatch Logs Group, etc |
| api          | api/function.tf        | portal_function          | Lambda Function, CloudWatch Logs Group                             |

- [Deployment Documenatation](#deployment-documenatation)
	- [Manual Deployment from Local](#manual-deployment-from-local)
	- [Automate Deployment via GitHub Actions](#automate-deployment-via-github-actions)
		- [Configure AWS Crendential in GitHub](#configure-aws-crendential-in-github)
		- [Run Workflow in GitHub Console](#run-workflow-in-github-console)
	- [Automate Deployment via Jenkins (Deprecated)](#automate-deployment-via-jenkins-deprecated)
		- [Deploy/Destroy a specific Component](#deploydestroy-a-specific-component)
		- [Deploy all Components](#deploy-all-components)

## Manual Deployment from Local

Firstly, follow [DEVELOPMENT.md](DEVELOPMENT.md) to setup your local environment.

Thne, create a `.env` from `env.sample`, and update environment variables as needed. The `.env` file won't be checked into your source code. After updated, these variables in `.env` will be injected into `Makefile` when you execute `make` commands. You can run `make pre-check` to validate these variables.

After done, run below `make` commands to deploy terraform resources to target AWS environment from local.

```bash
make plan
make apply
```

Run below `make` commands to destroy/remove terraform resources from target AWS environment from local.

```bash
make destroy
make apply
```

## Automate Deployment via GitHub Actions

### Configure AWS Crendential in GitHub

In order to deploy AWS resources using GitHub Actions workflow, we need to configure AWS credentials in workflow. As these variables are sensitive, I put them in GitHub Environment Variables. Below are the variables that need to be added.

> Read the blog if you are interested in [How to deploy Terraform resources to AWS using GitHub Actions via OIDC](https://dev.to/camillehe1992/deploy-terraform-resources-to-aws-using-github-actions-via-oidc-3b9g)

```yaml
AWS_REGION: ${{ vars.AWS_REGION }}
ROLE_TO_ASSUME: ${{ vars.ROLE_TO_ASSUME }}
ROLE_SESSION_NAME: ${{ vars.ROLE_SESSION_NAME }}
STATE_BUCKET: ${{ vars.STATE_BUCKET }}
```

### Run Workflow in GitHub Console

| Workflow             | File                  | Description                           |
| -------------------- | --------------------- | ------------------------------------- |
| Deploy API           | build_and_deploy.yaml | Deploy AWS resources to AWS account   |
| Destroy API          | build_and_detroy.yaml | Remove AWS resources from AWS account |
| Create Tag & Release | create_tag.yaml       | Create GitHub Tag and Release         |

## Automate Deployment via Jenkins (Deprecated)

[Jenkins](https://www.jenkins.io/doc/) is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.

In the project, we use `Jenkins` as our CICD tool. We have two Jenkinsfiles in the project root directory. Create pipelines in Jenkins using these files.

`Jenkinsfile` is used to deploy/destroy a specific component that you can choose by `Build with Parameters`.

`Jenkinsfile.ci` is used to deploy all components.

In order to deploy AWS resoources to AWS environment, you must setup AWS credentials in Jenkins -> Credentials -> System -> Global credentials -> Add Credentials.

- Kind: AWS Credentials
- Scope: Global
- ID: An internal unique ID by which these credentials are identified from jobs and other configuration
- Description: An optional description to help tell similar credentials apart
- Access Key ID and Secret Access Key: The AWS credentials for deployment

After created, you can use the credentials in your pipeline. In Jenkinsfile, leverage [Pipeline: AWS Step](https://www.jenkins.io/doc/pipeline/steps/pipeline-aws/) `withAWS` step to

I define an environment variable named `CREDENTIALS` and the value should be the `ID` you provided in the Credentials. Then, execute scripts in block `withAWS`.

The pipeline executes terraform scripts in container, which provide Terraform execution environment and providers pre-installed. The docker image is located in AWS ECR. You can use the official [image from Hashicorp](https://hub.docker.com/r/hashicorp/terraform/), but sometimes it’s wise to maintain your own Docker images with additional tools you may need. If you decided to use the official image, skip `ecr_login.sh` and replace environment variable `TF_IMAGE` with `hashicorp/terraform`.

### Deploy/Destroy a specific Component

 `Jenkinsfile` is used to deploy/destroy a specific component that you can choose by `Build with Parameters`.

- Choose `ENVIRONMENT` and `COMPONENT` to deploy.
- Check the `DESTROY` if this is a destroy action. Deploy as a default.
- Check `SKIP_APPLY` if you don't want to create AWS resources. Useful when you only focus on the changes.

![Build with Parameters](./images/jenkins-screenshot.png)

A view of pipeline stages.

![Stage View](./images/stage-view.png)

### Deploy all Components

`Jenkinsfile.ci` is used to deploy all components.

![Build Now](./images/build-now.png)

A view of pipeline stages.

![Stage View CI](./images/stage-view-ci.png)
