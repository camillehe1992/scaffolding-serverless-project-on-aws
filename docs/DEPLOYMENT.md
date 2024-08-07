# Deployment Documenatation

All AWS resources are spearated into three deployments: __common_infra__, __dynamodb__ and __api__. These resources can be deployed to AWS account from local environment or using CICD pipelines.

| Deployment   | File                   | Terraform Modules     | Main AWS Resources                                                 |
| ------------ | ---------------------- | --------------------- | ------------------------------------------------------------------ |
| common_infra | common_infra/roles.tf  | lambda_execution_role | IAM Role                                                           |
| common_infra | common_infra/layers.tf | dependencies_layer    | Lambda Layer                                                       |
| dynamodb     | dynamodb/main.tf       | dynamodb              | DynamoDB Table                                                     |
| api          | api/api_gateway.tf     | api_gateway           | API Gateway RestAPI, Stage, Deployment, CloudWatch Logs Group, etc |
| api          | api/function.tf        | portal_function       | Lambda Function, CloudWatch Logs Group                             |

Here is the detailed configuration of AWS resouces.

| AWS Service | Resource   | Resource Name                          | Configuration                                                  |
| ----------- | ---------- | -------------------------------------- | -------------------------------------------------------------- |
| IAM         | Role       | dev-todo-lambda-execution-role         | AWS Managed Policy, Customer Policy                            |
| DynamoDB    | Table      | dev-todo-users                         | Capacity Mode: Provisioned; Partition Key: id; Sort Key: email |
| DynamoDB    | Table      | dev-todo-todos                         | Capacity Mode: Provisioned; Partition Key: id; Sort Key: title |
| API Gateway | API        | dev-todo-portal                        | API Type: Rest API; API Endpoint Type: Regional                |
| Lambda      | Function   | dev-todo-portal                        | Runtime: Python 3.10; Archtecture: Arm 64                      |
| Lambda      | Layer      | dev-todo-dependencies                  | Runtime: Python 3.10; Archtecture: Arm 64                      |
| CloudWatch  | Logs Group | /aws/lambda/dev-todo-portal            | Log Class: Standard; Retention: 1 month                        |
| CloudWatch  | Logs Group | API-Gateway-Execution-Logs_{api_id}/v1 | Log Class: Standard; Retention: 1 month                        |

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

After done, run below `make` commands to deploy terraform resources to target AWS environment.

```bash
make deploy-all
```

After done, open the __swagger_url__ from Terraform outputs. The url format looks like

https://{api-id}.execute-api.{aws-region}.amazonaws.com/v1/swagger

> Please be noted, there is no reference between `userId` in `Todo` entity and `User` entity. `userId` can be any string when you create a todo via `POST /todos` interface.

Run below `make` commands to destroy/remove terraform resources from target AWS environment.

```bash
make destroy-all
```

You can deploy or destroy a particular deployment (common_infra, dynamodb, api) from dev environment with below commands.

```bash
make DEPLOYMENT=common_infra plan-apply
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

| Workflow             | File                         | Description                                                        |
| -------------------- | ---------------------------- | ------------------------------------------------------------------ |
| Plan & Apply         | [plan_apply.yaml][1]         | Deploy AWS resources to AWS                                        |
| Plan Destroy & Apply | [plan_destroy_apply.yaml][2] | Remove AWS resources from AWS                                      |
| Deploy to Dev        | [deploy_to_dev.yaml][4]      | Deploy AWS resources to AWS dev triggered by commit on main branch |
| Create Tag & Release | [create_tag.yaml][3]         | Create GitHub Tag and Release triggered by commit on main branch   |

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

[1]: https://github.com/camillehe1992/scaffolding-serverless-project-on-aws/actions/workflows/plan_apply.yaml
[2]: https://github.com/camillehe1992/scaffolding-serverless-project-on-aws/actions/workflows/plan_destroy_apply.yaml
[3]: https://github.com/camillehe1992/scaffolding-serverless-project-on-aws/actions/workflows/create_tag.yaml
[4]: https://github.com/camillehe1992/scaffolding-serverless-project-on-aws/actions/workflows/deploy_to_dev.yaml
