# Shared Terraform Modules

Generate Terraform modules documentation in various formats using [terraform-docs](https://terraform-docs.io/)

You can also have consistent execution through a `.terraform-docs.yaml` file.

__Please keep the terraform module documentation up-to-date.__

```bash
cd terraform/modules

tree
.
├── module-a
│   └── main.tf
├── module-b
│   └── main.tf
├── ...
└── .terraform-docs.yaml

# executing from parent
terraform-docs -c .terraform-docs.yaml module-a/

# executing from child
cd module-a/
terraform-docs -c ../.terraform-docs.yaml .

# or an absolute path
terraform-docs -c /path/to/parent/folder/.terraform-docs.yml .

# create a README.md file for a particular module
terraform-docs -c ../.terraform-docs.yaml module-a > module-a/README.md
```
