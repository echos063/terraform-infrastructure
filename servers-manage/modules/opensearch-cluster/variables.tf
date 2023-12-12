# Environment variable
variable "env" {
  description = "The environment (dev, stage, prod)"
  type        = string
}

# counterer
variable "opensearch_counter" {
  description = "The number of servers for opensearch-node"
  type        = number
}
variable "opensearch_dashboard_counter" {
  description = "The number of servers for opensearch-dashboard"
  type        = number
}

# Network
variable "backend_network_id" {
  description = "The ID of the network to connect to."
  type        = string
  default     = "dev"
}
variable "dmz_network_id" {
  description = "The ID of the network to connect to."
  type        = string
}

locals {
  opensearch-node_ips = {
    dev = ["10.11.110.18", "10.11.110.19"]
    stage = ["10.12.110.18", "10.12.110.19"]
    prod = ["10.13.110.18", "10.13.110.19"]
  }
  opensearch-node_macs = {
    dev = ["52:54:00:b2:11:36", "52:54:00:de:11:57"]
    stage = ["52:54:00:b2:12:36", "52:54:00:de:12:57"]
    prod = ["52:54:00:b2:13:36", "52:54:00:de:13:57"]
  }
  opensearch-dashboard_ips = {
    dev = "10.11.110.17"
    stage = "10.12.110.17"
    prod = "10.13.110.17"
  }
  opensearch-dashboard_macs = {
    dev = "52:54:00:ee:11:59"
    stage = "52:54:00:ee:12:59"
    prod = "52:54:00:ee:13:59"
  }
}