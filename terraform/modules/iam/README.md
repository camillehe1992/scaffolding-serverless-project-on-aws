# IAM Module

## Requirements

| Name      | Version  |
| --------- | -------- |
| terraform | >= 1.3.6 |
| aws       | ~> 5.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| aws  | 5.0.1   |

## Modules

No modules.

## Resources

| Name                                                                                                                                                       | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile)                          | resource    |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                              | resource    |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                  | resource    |
| [aws_iam_role_policy_attachment.customized](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)        | resource    |
| [aws_iam_role_policy_attachment.managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)           | resource    |
| [aws_iam_policy_document.ecs_tasks_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name                              | Description                                                      | Type           | Default                                       | Required |
| --------------------------------- | ---------------------------------------------------------------- | -------------- | --------------------------------------------- | :------: |
| assume\_role\_policy\_identifiers | The AWS service identitifers that are allowed to assume the role | `list(string)` | <pre>[<br>  "lambda.amazonaws.com"<br>]</pre> |    no    |
| aws\_managed\_policy\_arns        | A set of AWS managed policy ARN                                  | `set(string)`  | `[]`                                          |    no    |
| customized\_policies              | A map of JSON format of IAM policy                               | `map(string)`  | `{}`                                          |    no    |
| has\_iam\_instance\_profile       | If to create instance profile for the role                       | `bool`         | `false`                                       |    no    |
| name\_prefix                      | The prefix of the IAM role name                                  | `string`       | `""`                                          |    no    |
| role\_description                 | The description of IAM role                                      | `string`       | `""`                                          |    no    |
| role\_name                        | The name of IAM role                                             | `string`       | `"LambdaExecutionRole"`                       |    no    |
| tags                              | The key value pairs apply as tags to all resources in the module | `map(string)`  | `{}`                                          |    no    |

## Outputs

| Name      | Description |
| --------- | ----------- |
| iam\_role | n/a         |
