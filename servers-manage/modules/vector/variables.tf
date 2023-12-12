# Environment variable
variable "env" {
  description = "The environment (dev, stage, prod)"
  type        = string
}

# counterer
variable "vector_counter" {
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
  vector_ips = {
    dev = "10.11.110.24"
    stage = "10.12.110.24"
    prod = "10.13.110.24"
  }
    vector_macs = {
    dev = "52:54:00:82:11:d3"
    stage = "52:54:00:82:12:d3"
    prod = "52:54:00:82:13:d3"
  }
}

