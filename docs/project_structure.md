## Code Structure

The project structure shows as below. It contains threee parts:
- _terraform_ folder: all terraform resources and configurations. _deployment_ contains three componets:
  - _common_infra_: we defines all common infrastructure resources here, such as IAM roles and policies that referenced in other components. Resources that is depended by other resources should be deployed with high priority. In other word, _**Most Dependent first**_.
  - _frontend_: the core of project, including API Gateway, Lambda Function, CloudWatch Logs, etc.
  - _lambda_layers_: the Lambda Layers. We define Lambda Layers into a separated component because we put lambda dependencies here which is rarely modified. The benefits are not only a lightweighted Lambda deployment package, but also a distribution mechanism for libraries, custom runtimes, and other function dependencies.
- _src_ folder: all Lambda functions and layers code goes here.
- _tests_: for a standard project, test specs are necessary.
- _scripts_: I put all shell scripts here, including running terraform commands locally or in CICD pipelines.

> Note: we don't provide the terraform definition for database layer as we only focus on a quick start to guide you how to setup a Serverless based REST API in AWS using Terraform. You should be good to create a specific component in _terraform/deployment_ folder to define your storage service, for example, a DynamodDB table as you needs.

```bash
# tree -L 2 -all
.
├── .pre-commit-config.yaml     # configuration for pre-commit, such as lint, auto format, test
├── Jenkinsfile                 # Jenkins pipeline to deploy a specific component
├── Jenkinsfile.ci              # Jenkins pipeline to deploy all components in order
├── Makefile                    # A makefile to simplify your local deployment using shell scripts
├── requirements.txt        # Lambda functions external dependencies and dev dependencies
├── README.md
├── pylintrc                    # configuration for pylint
├── pytest.ini                  # configuration for pytest
├── scripts                     # shell scripts for makefile and Jenkins pipelines
├── src                         # lambda functions, layers, dependencies source code
│   ├── frontend
│   └── lambda_layers
├── swagger
│   ├── spec.yaml               # swagger specification
│   ├── index.html
├── terraform                   # terraform components and modules definition
│   ├── deployment
│   ├── modules
│   └── settings
└── tests                       # test files and cases, postman collection, unit test, E2E test, etc
    ├── data
    └── postman
    └── unit
    └── e2e
```

### Lint
Pylint is a static code analyser for Python 2 or 3.

Pylint analyses your code without actually running it. It checks for errors, enforces a coding standard, looks for code smells, and can make suggestions about how the code could be refactored.

> To keep code quality, passing lint is mandantry to commit your code using pre-commit.

See https://pypi.org/project/pylint/ fir more information.


### Pre Commit
A framework for managing and maintaining multi-language pre-commit hooks.

Git hook scripts are useful for identifying simple issues before submission to code review. We run our hooks on every commit to automatically point out issues in code such as missing semicolons, trailing whitespace, and debug statements. By pointing these issues out before code review, this allows a code reviewer to focus on the architecture of a change while not wasting time with trivial style nitpicks.

Each time you commit your code on local, these hooks will be triggered to validate as configured. Except for some pre-commit provided hooks, we also add another hook named _pylint_ to make sure your code follow and pass all rules defined in _pylintrc_ file. You can run `make lint` at any time to check the code lint result.

> Please note, `make lint` command checks both static code as well as rewrite terrafrom configuration files to a canonical format and style.

Currently, we enabled below hooks for pre-commit in configuration file `.git-commit-config.yaml`:
- trailing-whitespace
- check-yaml
- pylint
- pytest-check

which means you have to get all passed before creating a git commit successfully. 

Run `pre-commit install` to set up the git hook scripts. We also add the command in `make install`.

```bash
pre-commit install
# output: pre-commit installed at .git/hooks/pre-commit
```

You can enable more hooks as needed. See https://pre-commit.com/ for more information.

