##############################################
# GENERAL INFORMATION
##############################################

aws_profile = "756143471679_UserFull"
aws_region  = "cn-north-1"

tags = {
  environment = "dev"
  emails      = "group@example.com"
  application = "posts-demo"
  nickname    = "posts"
  createdby   = "scaffolding-serverless-project-on-aws"
}

environment = "dev"
nickname    = "posts"

##############################################
# COMMON ACCOUNT INFRA DEPLOYMENT INFORMATION
##############################################

api_gateway_vpc_endpoint_deployment = true
vpc_id                              = "vpc-06c47d9bb120348df"
subnet_ids                          = ["subnet-04839c488f31e2829", "subnet-08122d3fc6e3ce9b1"]
security_group_ids                  = ["sg-00fe42c9972b4e4af"]
