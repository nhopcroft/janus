
variable "deployment_environment" {
  type        = string
  description = "The deployment environment (e.g. dev, staging, prod)."
  sensitive   = false
  default = ""
}

locals {
  tags = {
    ProvisionedBy = "Terraform"
    SourceRepo = "https://github.com/nhopcroft/janus/"
    SourceLink = "https://github.com/nhopcroft/janus/tree/main/terraform/stacks/notetaking_ninja"
    Environment = var.deployment_environment != "" ? var.deployment_environment : "n/a"
    Stack = "notetaking_ninja"
    Note = "This stack contains static resources for notetaking.ninja"
  }
  suffix = length(var.deployment_environment) > 0 ? "-${var.deployment_environment}" : ""
}
