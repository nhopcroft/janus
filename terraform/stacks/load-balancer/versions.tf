
provider "aws" {
  region = "eu-north-1"
  default_tags {
    tags = local.tags
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.57.0"
    }
  }
}

locals {
  tags = {
    ProvisionedBy = "hand"
    SourceRepo = "https://github.com/nhopcroft/devops/"
    SourceLink = "https://github.com/nhopcroft/devops/tree/main/terraform/stacks/load-balancer"
    Environment = var.deployment_environment != "" ? var.deployment_environment : "n/a"
    Stack = "load-balancer"
    Note = "This stack contains load balancer resources"
  }

}
