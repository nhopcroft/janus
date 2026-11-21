
variable "region" {
  type        = string
  description = "The AWS region for the Cognito user pool."
}

variable "deployment_environment" {
  type        = string
  description = "The deployment environment for this Cognito user pool."
}

variable "ses_domain_identity" {
    type        = string
    description = "SES Domain identity to use"
}

data "aws_ses_domain_identity" "email" {
    domain = var.ses_domain_identity
}

locals {
  tags = {
    ProvisionedBy = "Terraform"
    SourceRepo    = "https://github.com/nhopcroft/janus/"
    SourceLink    = "https://github.com/nhopcroft/janus/tree/main/terraform/stacks/cognito"
    Environment   = var.deployment_environment
    Stack         = "cognito"
    Service       = "infrastructure"
  }
}
