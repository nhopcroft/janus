
provider "aws" {
  region = var.region
  default_tags {
    tags = local.tags
  }
  ignore_tags {
    keys = [ "awsApplication" ]
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.72.0"
    }
  }
}
