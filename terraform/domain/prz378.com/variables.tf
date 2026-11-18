
variable "region" {
  type       = string
  description = "Region to deploy to"
}

variable "deployment_environment" {
  type        = string
  description = "The deployment environment (e.g. dev, staging, prod)."
  sensitive   = false
}

variable "zone_id" {
  type        = string
  description = "The DNS zone ID for the email stack."
  sensitive   = false
}

variable "domain" {
    type        = string
    description = "Domain name"
}

locals {
    tags = {
        ProvisionedBy = "terraform"
        SourceRepo = "https://github.com/nhopcroft/janus/"
        Environment = var.deployment_environment != "" ? var.deployment_environment : "n/a"
        Stack = "email"
        Note = "This stack contains the email related resources"
        Documentation = "no documentation yet"
        Service = "infrastructure"
    }
    suffix = var.deployment_environment == "prod" ? "" : "-${var.deployment_environment}"
}
