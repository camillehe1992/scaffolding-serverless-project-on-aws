# Lambda Layer Module

## Requirements

| Name      | Version  |
| --------- | -------- |
| terraform | >= 1.3.6 |
| archive   | ~> 2.4.1 |
| aws       | ~> 5.0.0 |
| null      | ~> 3.2.2 |

## Providers

| Name    | Version |
| ------- | ------- |
| archive | 2.4.1   |
| aws     | 5.0.1   |
| null    | 3.2.2   |

## Modules

No modules.

## Resources

| Name                                                                                                                                    | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_lambda_layer_version.from_local](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource    |
| [aws_lambda_layer_version.from_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version)    | resource    |
| [aws_s3_object.file_upload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object)                      | resource    |
| [null_resource.pip_install](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)                      | resource    |
| [archive_file.custom](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file)                          | data source |
| [archive_file.dependencies](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file)                    | data source |
| [archive_file.s3_object](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file)                       | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                             | data source |

## Inputs

| Name         | Description                                                                              | Type           | Default                            | Required |
| ------------ | ---------------------------------------------------------------------------------------- | -------------- | ---------------------------------- | :------: |
| description  | The description of Lambda layer                                                          | `string`       | `""`                               |    no    |
| environment  | The environment of project, such as dev, int, prod                                       | `string`       | n/a                                |   yes    |
| from\_local  | Whether the package archived file is uploaded from local. Default false                  | `bool`         | `false`                            |    no    |
| from\_s3     | Whether the package source code is uploaded to s3, then create layer. Default false      | `bool`         | `false`                            |    no    |
| is\_custom   | Whether the package source code is saved in current file system. Default false           | `bool`         | `false`                            |    no    |
| layer\_name  | The name of Lambda layer                                                                 | `string`       | n/a                                |   yes    |
| nickname     | The nickname of project. Should be lowercase without special chars                       | `string`       | n/a                                |   yes    |
| pip\_install | Whether to pip install dependencies. Default false                                       | `bool`         | `false`                            |    no    |
| runtimes     | List of compatible runtimes of the Lambda layer, e.g. [python3.9]                        | `list(string)` | <pre>[<br>  "python3.9"<br>]</pre> |    no    |
| s3\_bucket   | S3 bucket location containing the function's deployment package. Conflicts with filename | `string`       | `""`                               |    no    |
| source\_path | Relative path to the function's requirement file within the current working directory    | `string`       | `"requirements.txt"`               |    no    |
| tags         | The key value pairs we want to apply as tags to the resources contained in this module   | `map(string)`  | n/a                                |   yes    |

## Outputs

| Name  | Description             |
| ----- | ----------------------- |
| layer | Lambda layer attributes |
