# Environment variable
variable "env" {
  description = "The environment (dev, stage, prod)"
  type        = string
  default     = "dev"
}

# counterer
variable "postgres_counter" {
  description = "The number of servers for vector"
  type        = number
}

# Network
variable "backend_network_id" {
  description = "The ID of the network to connect to."
  type        = string
}
variable "dmz_network_id" {
  description = "The ID of the network to connect to."
  type        = string
}

locals {
  postgres_ips = {
    dev = "10.11.110.14"
    stage = "10.12.110.14"
    prod = "10.13.110.14"
  }
  postgres_mac = {
    dev = "52:54:00:86:11:3c"
    stage = "52:54:00:86:12:3c"
    prod = "52:54:00:86:13:3c"
  }
}