terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "1.35.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.57.0"
    }
  }
}
