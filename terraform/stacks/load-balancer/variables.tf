
variable "deployment_environment" {
  type        = string
  description = "The deployment environment (e.g. dev, staging, prod)."
  sensitive   = false
  default = ""
}


locals {
  tags = {
    ProvisionedBy = "hand"
    SourceRepo = "https://github.com/nhopcroft/janus/"
    SourceLink = "https://github.com/nhopcroft/janus/tree/main/terraform/stacks/load-balancer"
    Environment = var.deployment_environment != "" ? var.deployment_environment : "n/a"
    Stack = "load-balancer"
    Note = "This stack contains load balancer resources"
  }
  suffix = length(var.deployment_environment) > 0 ? "-${var.deployment_environment}" : ""
}
