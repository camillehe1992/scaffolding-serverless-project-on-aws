## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamodb_tables"></a> [dynamodb\_tables](#module\_dynamodb\_tables) | ../../modules/dynamodb | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | The nickname of project. Should be lowercase without special chars | `string` | n/a | yes |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY\_PER\_REQUEST | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_env"></a> [env](#input\_env) | The environment of project, such as dev, int, prod | `string` | `"dev"` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | Number of read units for this table. If the billing\_mode is PROVISIONED, this field is required | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The key value pairs we want to apply as tags to the resources | `map(string)` | `{}` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | Number of write units for this table. If the billing\_mode is PROVISIONED, this field is required | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_arns"></a> [dynamodb\_table\_arns](#output\_dynamodb\_table\_arns) | n/a |
