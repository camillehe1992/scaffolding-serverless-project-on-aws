## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 1.8.0  |
| aws       | ~> 5.80.0 |

## Providers

| Name | Version |
| ---- | ------- |
| aws  | 5.0.1   |

## Modules

No modules.

## Resources

| Name                                                                                                                             | Type        |
| -------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_vpc_endpoint.private_api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource    |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition)                | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                      | data source |

## Inputs

| Name                                    | Description                                                                            | Type           | Default | Required |
| --------------------------------------- | -------------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| api\_gateway\_vpc\_endpoint\_deployment | Defines if the VPC endpoint for API Gateway will be deployed or not                    | `bool`         | `false` |    no    |
| security\_group\_ids                    | Security Group ids for Lambda functions wich runs in a VPC                             | `list(string)` | n/a     |   yes    |
| subnet\_ids                             | Subnet ids for Lambda functions wich runs in a VPC                                     | `list(string)` | n/a     |   yes    |
| tags                                    | The key value pairs we want to apply as tags to the resources contained in this module | `map(string)`  | n/a     |   yes    |
| vpc\_id                                 | The Id of the VPC we want to associate with the VPC Endpoint                           | `string`       | n/a     |   yes    |

## Outputs

| Name                | Description |
| ------------------- | ----------- |
| interface\_endpoint | n/a         |
