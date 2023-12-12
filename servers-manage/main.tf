# Networks creating
module "network_config" {
  env             = var.env
  source          = "./modules/networks"
  backend_network_name    = "${var.env}-projectname_infra_backend_net"
  backend_bridge_name     = "${var.env}-br-inf-bk"
  backend_domain          = "backend.projectname.local"
  dmz_network_name        = "${var.env}-projectname_infra_dmz_net"
  dmz_bridge_name         = "${var.env}-br-inf-dm"
  dmz_domain              = "dmz.projectname.local"
  backend_network_address = local.backend_network_address
  dmz_network_address     = local.dmz_network_address
}

# Projects creating
module "opensearch_cluster" {
  env = var.env
  source = "./modules/opensearch-cluster"
  opensearch_counter = 0
  opensearch_dashboard_counter = 0
  backend_network_id = module.network_config.backend_network_id
  dmz_network_id = module.network_config.dmz_network_id
}

module "vector" {
  env = var.env
  source = "./modules/vector"
  vector_counter = 0
  backend_network_id = module.network_config.backend_network_id
  dmz_network_id = module.network_config.dmz_network_id
}

module "keycloak" {
  env = var.env
  source = "./modules/keycloak"
  keycloak_counter = 0
  backend_network_id = module.network_config.backend_network_id
  dmz_network_id = module.network_config.dmz_network_id
}

module "postgres-infra" {
  env = var.env
  source = "./modules/postgres-infra"
  postgres_counter = 0
  backend_network_id = module.network_config.backend_network_id
  dmz_network_id = module.network_config.dmz_network_id
}

module "nginx-balancer" {
  env = var.env
  source = "./modules/nginx-balancer"
  nginx_counter = 0
  backend_network_id = module.network_config.backend_network_id
  dmz_network_id = module.network_config.dmz_network_id
}
