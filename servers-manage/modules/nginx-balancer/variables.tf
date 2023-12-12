# Environment variable
variable "env" {
  description = "The environment (dev, stage, prod)"
  type        = string
}

# counterer
variable "nginx_counter" {
  description = "The number of servers for opensearch-node"
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
  nginx_balancer_ips = {
    dev = "10.11.110.101"
    stage = "10.12.110.101"
    prod = "10.13.110.101"
  }
}