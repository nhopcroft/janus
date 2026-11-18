
variable "region" {
  type       = string
  description = "Region to deploy to"
}

variable "deployment_environment" {
  type        = string
  description = "The deployment environment (e.g. dev, staging, prod)."
  sensitive   = false
}

locals {
    tags = {
        ProvisionedBy = "terraform"
        SourceRepo = "https://github.com/nhopcroft/janus/"
        Environment = var.deployment_environment != "" ? var.deployment_environment : "n/a"
        Stack = "notetaking.ninja"
        Note = "This stack contains the definiton of notetaking.ninja"
        Documentation = "no documentation yet"
        Service = "infrastructure"
    }
    suffix = var.deployment_environment == "prod" ? "" : "-${var.deployment_environment}"
}
