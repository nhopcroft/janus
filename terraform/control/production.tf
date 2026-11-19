
locals {
  enabled_production_stacks = [for stack in local.production_stacks : stack if stack.enabled == true]

  production_stacks = [
    {
      name         = "Runners-prod"
      description  = "Shared CI Runners for all Stacks"
      project_root = "terraform/stacks/runners"
      id           = "runners-prod"
      space        = spacelift_space.production.id
      branch      = "main"
      enabled      = false
    },
    {
      name         = "Load-balancer"
      description  = "Shared load balancer"
      project_root = "terraform/stacks/load-balancer"
      id           = "load-balancer"
      space        = spacelift_space.production.id
      branch      = "main"
      enabled      = false
    },
    {
      name         = "DNS"
      description  = "DNS zones"
      project_root = "terraform/stacks/dns"
      id           = "dns"
      space        = spacelift_space.production.id
      branch      = "main"
      enabled      = false
    },
    {
      name         = "notetaking-ninja"
      description  = "Notetaking ninja domain definition"
      project_root = "terraform/domain/notetaking.ninja"
      id           = "notetaking-ninja"
      space        = spacelift_space.production.id
      branch      = "main"
      enabled      = true
    },
    {
      name         = "notetaking-ninja-dns"
      description  = "DNS for notetaking.ninja"
      project_root = "terraform/stacks/dns"
      id           = "notetaking-ninja-dns"
      space        = spacelift_space.production.id
      branch      = "main"
      enabled      = true
    },
    {
      name         = "notetaking-ninja-email"
      description  = "Email for notetaking.ninja"
      project_root = "terraform/stacks/email"
      id           = "notetaking-ninja-email"
      space        = spacelift_space.production.id
      branch      = "main"
      enabled      = true
    },
    {
      name         = "taking-ninja"
      description  = "taking ninja domain definition"
      project_root = "terraform/domain/taking.ninja"
      id           = "taking-ninja"
      space        = spacelift_space.production.id
      branch      = "main"
      enabled      = true
    },
    {
      name         = "taking-ninja-dns"
      description  = "DNS for taking.ninja"
      project_root = "terraform/stacks/dns"
      id           = "taking-ninja-dns"
      space        = spacelift_space.production.id
      branch      = "main"
      enabled      = true
    },
    {
      name         = "taking-ninja-email"
      description  = "Email for taking.ninja"
      project_root = "terraform/stacks/email"
      id           = "taking-ninja-email"
      space        = spacelift_space.production.id
      branch      = "main"
      enabled      = true
    },
    {
      name         = "prz378"
      description  = "Domain definition for prz378.com"
      project_root = "terraform/domain/prz378.com"
      id           = "prz378"
      space        = spacelift_space.production.id
      branch      = "main"
      enabled      = true
    },
    {
      name         = "prz378-dns"
      description  = "DNS for prz378.com"
      project_root = "terraform/stacks/dns"
      id           = "prz378-dns"
      space        = spacelift_space.production.id
      branch      = "main"
      enabled      = true
    },
    {
      name         = "prz378-email"
      description  = "email identity for prz378.com"
      project_root = "terraform/stacks/email"
      id           = "prz378-email"
      space        = spacelift_space.production.id
      branch      = "main"
      enabled      = true
    }
  ]
}

resource "spacelift_space" "production" {
    name        = "Production"
    description = "Production"
    inherit_entities = true
}

resource "spacelift_context" "production" {
    name        = "Production Context"
    description = "Context for Production"
    space_id    = spacelift_space.production.id
}

resource "spacelift_environment_variable" "deployment_environment_production" {
    name        = "TF_VAR_deployment_environment"
    description = "Environment for Production"
    context_id  = spacelift_context.production.id
    value       = "prod"
    write_only  = false
}

resource "spacelift_environment_variable" "base_priority_production" {
    name        = "TF_VAR_base_priority"
    description = "Load balancer priority"
    context_id  = spacelift_context.production.id
    value       = 100
    write_only  = false
}

resource "spacelift_context_attachment" "production" {
  for_each = { for stack in local.enabled_production_stacks : stack.name => stack }

  context_id = spacelift_context.production.id
  stack_id   = each.value.id

  depends_on = [
    spacelift_stack.children,
    spacelift_context.production
  ]
}

//
//
//

resource "spacelift_stack_dependency" "prz378_dns" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "prz378-dns"] == [true] ? 1 : 0
  stack_id            = spacelift_stack.children["prz378-dns"].id
  depends_on_stack_id = spacelift_stack.children["prz378"].id
}

resource "spacelift_stack_dependency" "prz378_email" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "prz378-email"] == [true] ? 1 : 0
  stack_id            = spacelift_stack.children["prz378-email"].id
  depends_on_stack_id = spacelift_stack.children["prz378-dns"].id
}

resource "spacelift_stack_dependency" "notetaking_dns" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "notetaking-ninja-dns"] == [true] ? 1 : 0
  stack_id            = spacelift_stack.children["notetaking-ninja-dns"].id
  depends_on_stack_id = spacelift_stack.children["notetaking-ninja"].id
}

resource "spacelift_stack_dependency" "notetaking_email" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "notetaking-ninja-email"] == [true] ? 1 : 0
  stack_id            = spacelift_stack.children["notetaking-ninja-email"].id
  depends_on_stack_id = spacelift_stack.children["notetaking-ninja-dns"].id
}

resource "spacelift_stack_dependency" "taking_dns" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "taking-ninja-dns"] == [true] ? 1 : 0
  stack_id            = spacelift_stack.children["taking-ninja-dns"].id
  depends_on_stack_id = spacelift_stack.children["taking-ninja"].id
}

resource "spacelift_stack_dependency" "taking_email" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "taking-ninja-email"] == [true] ? 1 : 0
  stack_id            = spacelift_stack.children["taking-ninja-email"].id
  depends_on_stack_id = spacelift_stack.children["taking-ninja-dns"].id
}

//
//
//

resource "spacelift_stack_dependency_reference" "prz378_dns_domain" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "prz378-dns"] == [true] ? 1 : 0
  stack_dependency_id = spacelift_stack_dependency.prz378_dns[0].id
  output_name         = "TF_VAR_domain"
  input_name          = "TF_VAR_domain"
}

resource "spacelift_stack_dependency_reference" "prz378_email_domain" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "prz378-email"] == [true] ? 1 : 0
  stack_dependency_id = spacelift_stack_dependency.prz378_email[0].id
  output_name         = "TF_VAR_domain"
  input_name          = "TF_VAR_domain"
}


resource "spacelift_stack_dependency_reference" "prz378_email_zone" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "prz378-email"] == [true] ? 1 : 0
  stack_dependency_id = spacelift_stack_dependency.prz378_email[0].id
  output_name         = "TF_VAR_zone_id"
  input_name          = "TF_VAR_zone_id"
}

resource "spacelift_stack_dependency_reference" "notetaking_dns_domain" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "notetaking-ninja-dns"] == [true] ? 1 : 0
  stack_dependency_id = spacelift_stack_dependency.notetaking_dns[0].id
  output_name         = "TF_VAR_domain"
  input_name          = "TF_VAR_domain"
}

resource "spacelift_stack_dependency_reference" "notetaking_email_domain" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "notetaking-ninja-email"] == [true] ? 1 : 0
  stack_dependency_id = spacelift_stack_dependency.notetaking_email[0].id
  output_name         = "TF_VAR_domain"
  input_name          = "TF_VAR_domain"
}

resource "spacelift_stack_dependency_reference" "notetaking_email_zone" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "notetaking-ninja-email"] == [true] ? 1 : 0
  stack_dependency_id = spacelift_stack_dependency.notetaking_email[0].id
  output_name         = "TF_VAR_zone_id"
  input_name          = "TF_VAR_zone_id"
}


resource "spacelift_stack_dependency_reference" "taking_dns_domain" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "taking-ninja-dns"] == [true] ? 1 : 0
  stack_dependency_id = spacelift_stack_dependency.taking_dns[0].id
  output_name         = "TF_VAR_domain"
  input_name          = "TF_VAR_domain"
}

resource "spacelift_stack_dependency_reference" "taking_email_domain" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "taking-ninja-email"] == [true] ? 1 : 0
  stack_dependency_id = spacelift_stack_dependency.taking_email[0].id
  output_name         = "TF_VAR_domain"
  input_name          = "TF_VAR_domain"
}


resource "spacelift_stack_dependency_reference" "taking_email_zone" {
  count               = [for stack in local.production_stacks : stack.enabled if stack.name == "taking-ninja-email"] == [true] ? 1 : 0
  stack_dependency_id = spacelift_stack_dependency.taking_email[0].id
  output_name         = "TF_VAR_zone_id"
  input_name          = "TF_VAR_zone_id"
}
