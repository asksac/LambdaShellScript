/**
 * # Terraform Module - LambdaShellScript
 *
 * This Terraform module deploys a new Lambda function that uses a Custom Runtime 
 * and a handler written in Bourne Shell. This is to demonstrate yet another flexibility
 * that AWS Serverless platform offers to run your existing shell scripts. 
 * 
 * ### Usage: 
 * 
 * ```hcl
 * module "lambda_sh" {
 *   source                 = "./LambdaShellScript"
 * 
 *   app_name               = "LambdaShellScript"
 *   aws_env                = "Dev"
 *   aws_profile            = "default"
 *   aws_region             = "us-east-1"
 *   app_shortcode          = "LamSH"
 *   principal_arn          = "arn:aws:iam::012345678910:role/MyDevOpsRole"
 *   source_cidr_blocks     = [ "200.20.2.0/24" ]
 *   subnet_ids             = [ "subnet-a1b2c3d4", "subnet-e5f6a7b8", "subnet-c9d0e1f2" ]
 *   vpc_id                 = "vpc-f0e1d2c3b4"
 * }
 * ```
 *
 */

data "aws_caller_identity" "current" {}

data "aws_vpc" "given" {
  id                      = var.vpc_id
}

data "aws_subnet" "given" {
  count                   = length(var.subnet_ids)
  id                      = var.subnet_ids[count.index]
}

locals {
  # Common tags to be assigned to all resources
  common_tags             = {
    Application           = var.app_name
    Environment           = var.aws_env
  }

  account_id              = data.aws_caller_identity.current.account_id
}

