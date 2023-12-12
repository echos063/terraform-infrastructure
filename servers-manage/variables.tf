# Environment variable
variable "env" {
  description = "The environment (dev, stage, prod)"
  type        = string
  default     = "dev"
}

# Network backend
locals {
  backend_subnet_map = {
    dev   = "10.11.110.0/24"
    stage = "10.12.110.0/24"
    prod  = "10.13.110.0/24"
  }

 dmz_subnet_map = {
    dev   = "10.11.220.0/24"
    stage = "10.12.220.0/24"
    prod  = "10.13.220.0/24"
  }

  backend_network_address = local.backend_subnet_map[var.env]
  dmz_network_address = local.dmz_subnet_map[var.env]
}
