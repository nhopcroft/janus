
locals {
  tags = {
    ProvisionedBy = "Terraform"
    SourceRepo = "https://github.com/nhopcroft/janus/"
    SourceLink = "https://github.com/nhopcroft/janus/tree/main/terraform/stacks/dns"
    Environment = var.deployment_environment != "" ? var.deployment_environment : "n/a"
    Stack = "DNS"
    Note = "This stack contains DNS resources"
  }
  suffix = length(var.deployment_environment) > 0 ? "-${var.deployment_environment}" : ""
}
