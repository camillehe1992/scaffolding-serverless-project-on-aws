## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.role_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.customized_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.customized_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.managed_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | The assume role policy document in JSON format that defines which entities can assume the role | `string` | `null` | no |
| <a name="input_aws_managed_policy_arns"></a> [aws\_managed\_policy\_arns](#input\_aws\_managed\_policy\_arns) | A set of AWS managed policy ARNs to attach to the role | `set(string)` | `[]` | no |
| <a name="input_has_iam_instance_profile"></a> [has\_iam\_instance\_profile](#input\_has\_iam\_instance\_profile) | Whether to create an IAM instance profile for the role (useful for EC2 instances) | `bool` | `false` | no |
| <a name="input_principals"></a> [principals](#input\_principals) | A map of principals that can assume the role. The key is the principal type, value is a list of principal identifiers | <pre>map(object({<br/>    type        = string<br/>    identifiers = list(string)<br/>  }))</pre> | <pre>{<br/>  "Service": {<br/>    "identifiers": [<br/>      "ec2.amazonaws.com"<br/>    ],<br/>    "type": "Service"<br/>  }<br/>}</pre> | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | The description of the IAM role | `string` | `"IAM role created by Terraform"` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name of the IAM role | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_user_managed_policies"></a> [user\_managed\_policies](#input\_user\_managed\_policies) | A map of custom IAM policies to create and attach to the role. The key is the policy name suffix, value is the policy document in JSON format | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_profile_arn"></a> [instance\_profile\_arn](#output\_instance\_profile\_arn) | The ARN of the IAM instance profile (if created) |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The Amazon Resource Name (ARN) of the IAM role |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | The ID of the IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The name of the IAM role |
| <a name="output_role_unique_id"></a> [role\_unique\_id](#output\_role\_unique\_id) | The unique ID assigned by AWS to the IAM role |
