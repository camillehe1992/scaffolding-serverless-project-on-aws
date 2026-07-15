# Common variables and configuration for all environments

locals {
  # Common tags for all resources
  common_tags = {
    Project    = "scaffolding-serverless-project-on-aws"
    ManagedBy  = "terragrunt"
    Terraform  = "true"
    CostCenter = "platform"
    Owner      = "platform-team"
  }

  # Application name
  application_name = "slstemplate"
}
