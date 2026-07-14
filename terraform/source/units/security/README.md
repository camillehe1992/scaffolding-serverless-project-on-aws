## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_execution_role"></a> [lambda\_execution\_role](#module\_lambda\_execution\_role) | ../../modules/iam_role | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.dynamodb_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | The name of application. Should be lowercase without special chars | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The environment of application, such as dev, prod | `string` | `"dev"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to the resources contained in this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_execution_role_arn"></a> [lambda\_execution\_role\_arn](#output\_lambda\_execution\_role\_arn) | The ARN of the Lambda execution role |
