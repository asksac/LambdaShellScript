terraform {
  required_version        = ">= 1.1.0"
  required_providers {
    aws                   = ">= 4.6.0"
    archive               = "~> 2.2.0"
  }
}

provider "aws" {
  profile                 = var.aws_profile
  region                  = var.aws_region
}

