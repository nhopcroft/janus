
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
