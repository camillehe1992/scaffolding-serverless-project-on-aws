## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | ../../modules/api_gateway | n/a |
| <a name="module_portal_function"></a> [portal\_function](#module\_portal\_function) | ../../modules/lambda_function | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lambda_layer_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [local_file.dependencies_zip_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | The name of project. Should be lowercase without special chars | `string` | n/a | yes |
| <a name="input_architecture"></a> [architecture](#input\_architecture) | The type of computer processor that Lambda uses to run the function | `string` | `"arm64"` | no |
| <a name="input_dependencies_layer_file_path"></a> [dependencies\_layer\_file\_path](#input\_dependencies\_layer\_file\_path) | Path to the file that be read as Lambda dependencies layer | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The environment of project, such as dev, int, prod | `string` | `"dev"` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | The handler of Lambda function | `string` | `"app.main.lambda_handler"` | no |
| <a name="input_lambda_environment_variables"></a> [lambda\_environment\_variables](#input\_lambda\_environment\_variables) | The environment variables of Lambda function | `map(string)` | `{}` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | The runtime of Lambda function | `string` | `"python3.12"` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Specifies the number of days you want to retain API Gateway and Lambda function logs | `number` | `30` | no |
| <a name="input_output_path"></a> [output\_path](#input\_output\_path) | The zip file path of Lambda function | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN of Lambda execution role | `string` | n/a | yes |
| <a name="input_source_dir"></a> [source\_dir](#input\_source\_dir) | The directory of Lambda function source code | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to the resources contained in this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gateway_rest_api"></a> [api\_gateway\_rest\_api](#output\_api\_gateway\_rest\_api) | The API Gateway REST API |
| <a name="output_dependencies_layer_arn"></a> [dependencies\_layer\_arn](#output\_dependencies\_layer\_arn) | The ARN of the Lambda layer that contains the dependencies |
| <a name="output_function"></a> [function](#output\_function) | The ARN of the portal function |
| <a name="output_invoke_url"></a> [invoke\_url](#output\_invoke\_url) | The invoke URL of the API Gateway REST API |
| <a name="output_swagger_url"></a> [swagger\_url](#output\_swagger\_url) | The Swagger URL of the API Gateway REST API |
