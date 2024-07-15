## Requirements

| Name      | Version  |
| --------- | -------- |
| terraform | >= 1.8.0 |
| aws       | ~> 5.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| aws  | 5.31.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                            | Type        |
| ----------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_api_gateway_deployment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment)           | resource    |
| [aws_api_gateway_method_settings.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource    |
| [aws_api_gateway_rest_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api)               | resource    |
| [aws_api_gateway_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage)                     | resource    |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)               | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                   | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition)                               | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                     | data source |

## Inputs

| Name                   | Description                                                                                      | Type          | Default                                                           | Required |
| ---------------------- | ------------------------------------------------------------------------------------------------ | ------------- | ----------------------------------------------------------------- | :------: |
| environment            | The environment of project, such as dev, int, prod                                               | `string`      | n/a                                                               |   yes    |
| invoke\_arn            | ARN to be used for invoking Lambda Function from API Gateway                                     | `string`      | n/a                                                               |   yes    |
| log\_retention\_days   | Specifies the number of days you want to retain log events in the specific api gateway log group | `number`      | `30`                                                              |    no    |
| nickname               | The nickname of project. Should be lowercase without special chars                               | `string`      | n/a                                                               |   yes    |
| rest\_api\_description | The description of API Gateway Rest API                                                          | `string`      | `"Rest API for serverless project that triggers lambda function"` |    no    |
| rest\_api\_name        | The name of API Gateway Rest API                                                                 | `string`      | `"rest-api"`                                                      |    no    |
| stage\_name            | The stage name of API Gateway Rest API                                                           | `string`      | `"v1"`                                                            |    no    |
| swagger\_file          | The path of Swagger specification of API Gateway Rest API                                        | `string`      | n/a                                                               |   yes    |
| tags                   | The key value pairs we want to apply as tags to the resources contained in this module           | `map(string)` | n/a                                                               |   yes    |

## Outputs

| Name            | Description |
| --------------- | ----------- |
| cw\_logs\_group | n/a         |
| rest\_api       | n/a         |
| stage           | n/a         |
