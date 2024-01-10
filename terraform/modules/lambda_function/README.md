# Module Overview

The detailed information about the module.

## Providers

| Name    | Version |
| ------- | ------- |
| archive | n/a     |
| aws     | n/a     |

The module automatically inherits default provider configurations from its parent.

## Resources

| Name                                                                                                                              | Type        |
| --------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource    |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)           | resource    |
| [aws_lambda_permission.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission)       | resource    |
| [archive_file.this](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file)                      | data source |

## Inputs

| Name                   | Description                                                                            | Type                                                          | Default       | Required |
| ---------------------- | -------------------------------------------------------------------------------------- | ------------------------------------------------------------- | ------------- | :------: |
| description            | The description of Lambda function                                                     | `string`                                                      | `""`          |    no    |
| environment            | The environment of application                                                         | `string`                                                      | n/a           |   yes    |
| environment\_variables | A set of environment variables of Lambda function                                      | `map(string)`                                                 | `{}`          |    no    |
| function\_name         | The Lambda function name                                                               | `string`                                                      | n/a           |   yes    |
| handler                | The handler of Lambda function                                                         | `string`                                                      | n/a           |   yes    |
| lambda\_permissions    | A map of lambda permissions                                                            | ```map(object({ principal = string source_arn = string }))``` | `{}`          |    no    |
| layers                 | A list of Lambda function associated layers ARN                                        | `list(string)`                                                | `[]`          |    no    |
| memory\_size           | The memory size (MiB) of Lambda function                                               | `number`                                                      | `128`         |    no    |
| nickname               | The nickname of application. Must be lowercase without special chars                   | `string`                                                      | n/a           |   yes    |
| output\_path           | The zip file name of Lambda function source code                                       | `string`                                                      | n/a           |   yes    |
| retention\_in\_days    | The retention (days) of Lambda function Cloudwatch logs group                          | `number`                                                      | `14`          |    no    |
| role\_arn              | The ARN of Lambda function excution role                                               | `string`                                                      | n/a           |   yes    |
| runtime                | The runtime of Lambda function                                                         | `string`                                                      | `"python3.9"` |    no    |
| security\_group\_ids   | A list of Security group Ids                                                           | `list(string)`                                                | `[]`          |    no    |
| source\_dir            | The source dir of Lambda function source code. Conflict with source\_file              | `string`                                                      | `null`        |    no    |
| source\_file           | The file name of Lambda function source code                                           | `string`                                                      | `null`        |    no    |
| subnet\_ids            | A list of Subnet Ids                                                                   | `list(string)`                                                | `[]`          |    no    |
| tags                   | The key value pairs we want to apply as tags to the resources contained in this module | `map(string)`                                                 | `{}`          |    no    |
| timeout                | The timeout (seconds) of Lambda function                                               | `number`                                                      | `60`          |    no    |

## Outputs

| Name     | Description |
| -------- | ----------- |
| function | n/a         |
