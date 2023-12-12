# Environment variable
variable "env" {
  description = "The environment (dev, stage, prod)"
  type        = string
  default     = "dev"
}

# Counter
variable "keycloak_counter" {
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
  keycloak_ips = {
    dev = "10.11.110.20"
    stage = "10.12.110.20"
    prod = "10.13.110.20"
  }
    keycloak_mac = {
    dev = "52:54:00:ce:11:e3"
    stage = "52:54:00:ce:12:e3"
    prod = "52:54:00:ce:13:e3"
  }
}