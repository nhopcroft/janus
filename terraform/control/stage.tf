
locals {
  enabled_stage_stacks = [for stack in local.stage_stacks : stack if stack.enabled == true]

  stage_stacks = [
    {
      name         = "Runners-stage"
      description  = "Shared CI Runners for all Stacks"
      project_root = "terraform/stacks/runners"
      id           = "runners-stage"
      space        = spacelift_space.stage.id
      branch      = "stage"
      enabled      = false
    }
  ]
}

data "spacelift_space" "root" {
    space_id = "root"
}

resource "spacelift_space" "stage" {
    name        = "Stage"
    description = "Staging"
    inherit_entities = true
}

resource "spacelift_context" "stage" {
    name        = "Stage Context"
    description = "Context for Staging"
    space_id    = spacelift_space.stage.id
}

resource "spacelift_environment_variable" "deployment_environment_stage" {
    name        = "TF_VAR_deployment_environment"
    description = "Environment for Staging"
    context_id  = spacelift_context.stage.id
    value       = "stage"
    write_only  = false
}

resource "spacelift_environment_variable" "base_priority_stage" {
    name        = "TF_VAR_base_priority"
    description = "Load balancer priority"
    context_id  = spacelift_context.stage.id
    value       = 20100
    write_only  = false
}

resource "spacelift_context_attachment" "stage" {
  for_each = { for stack in local.enabled_stage_stacks : stack.name => stack }

  context_id = spacelift_context.stage.id
  stack_id   = each.value.id

  depends_on = [
    spacelift_stack.children,
    spacelift_context.stage
  ]
}
