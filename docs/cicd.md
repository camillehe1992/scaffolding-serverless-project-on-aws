# CICD Setup

Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.

In the project, we use `Jenkins` as our CICD tool. We have two Jenkinsfiles in the project root directory. Create pipelines in Jenkins using these files.

In order to deploy AWS resoources to AWS environment, you must setup AWS credentials in Jenkins -> Credentials -> System -> Global credentials -> Add Credentials.

- Kind: AWS Credentials
- Scope: Global
- ID: An internal unique ID by which these credentials are identified from jobs and other configuration
- Description: An optional description to help tell similar credentials apart
- Access Key ID and Secret Access Key: The AWS credentials for deployment

After created, you can use the credentials in your pipeline. In Jenkinsfile, leverage [Pipeline: AWS Step](https://www.jenkins.io/doc/pipeline/steps/pipeline-aws/) `withAWS` step to

I define an environment variable named `CREDENTIALS` and the value should be the `ID` you provided in the Credentials. Then, execute scripts in block `withAWS`.

The pipeline executes terraform scripts in container, which provide Terraform execution environment and providers pre-installed. The docker image is located in AWS ECR. You can use the official [image from Hashicorp](https://hub.docker.com/r/hashicorp/terraform/), but sometimes it’s wise to maintain your own Docker images with additional tools you may need. If you decided to use the official image, skip `ecr_login.sh` and replace environment variable `TF_IMAGE` with `hashicorp/terraform`.

## Deploy/Destroy a specific Component

 `Jenkinsfile` is used to deploy/destroy a specific component that you can choose by `Build with Parameters`.
- Choose `ENVIRONMENT` and `COMPONENT` to deploy.
- Check the `DESTROY` if this is a destroy action. Deploy as a default.
- Check `SKIP_APPLY` if you don't want to create AWS resources. Useful when you only focus on the changes.

![Build with Parameters](./jenkins-screenshot.png)

A view of pipeline stages.

![Stage View](./stage-view.png)


## Deploy all Components

`Jenkinsfile.ci` is used to deploy all components.

![Build Now](./build-now.png)

A view of pipeline stages.

![Stage View CI](./stage-view-ci.png)


## Reference

- https://www.jenkins.io/doc/