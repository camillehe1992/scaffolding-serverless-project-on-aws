# Security unit configuration - shared across all environments

# Unit-specific inputs for Security resources
inputs = {}

# Unit-specific locals
locals {
  unit_tags = {
    Unit = "security"
  }
}
