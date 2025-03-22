
module "network" {
  source         = "./modules/${var.cloud_provider}/network"
  cloud_provider = var.cloud_provider
  region         = var.region[var.cloud_provider]
}

# module "management_server" {
#   source         = "./modules/${var.cloud_provider}/compute"
#   role           = "management"
#   cloud_provider = var.cloud_provider
#   instance_type  = var.instance_type[var.cloud_provider]["management"]
#   vm_count       = var.vm_count[var.cloud_provider]["management"]
#   region         = var.region[var.cloud_provider]
#   ssh_key        = var.ssh_key
#   network_id     = module.network.network_id
#   firewall_id = module.network.firewall_id
# }

# module "k8s_master" {
#   source         = "./modules/${var.cloud_provider}/compute"
#   role           = "k8s_master"
#   cloud_provider = var.cloud_provider
#   instance_type  = var.instance_type[var.cloud_provider]["k8s_master"]
#   vm_count       = var.vm_count[var.cloud_provider]["k8s_master"]
#   region         = var.region[var.cloud_provider]
#   ssh_key        = var.ssh_key
#   network_id     = module.network.network_id
#   firewall_id = module.network.firewall_id
# }

# module "k8s_worker" {
#   source         = "./modules/${var.cloud_provider}/compute"
#   role           = "k8s_worker"
#   cloud_provider = var.cloud_provider
#   instance_type  = var.instance_type[var.cloud_provider]["k8s_worker"]
#   vm_count       = var.vm_count[var.cloud_provider]["k8s_worker"]
#   region         = var.region[var.cloud_provider]
#   ssh_key        = var.ssh_key
#   network_id     = module.network.network_id
#   firewall_id = module.network.firewall_id
# }

# module "storage_server" {
#   source         = "./modules/${var.cloud_provider}/compute"
#   role           = "storage"
#   cloud_provider = var.cloud_provider
#   instance_type  = var.instance_type[var.cloud_provider]["storage"]
#   vm_count       = var.vm_count[var.cloud_provider]["storage"]
#   region         = var.region[var.cloud_provider]
#   ssh_key        = var.ssh_key
#   network_id     = module.network.network_id
#   firewall_id = module.network.firewall_id
#   extra_disks    = try(var.extra_disks[var.cloud_provider], [])
# }

# module "monitoring_server" {
#   source         = "./modules/${var.cloud_provider}/compute"
#   role           = "monitoring"
#   cloud_provider = var.cloud_provider
#   instance_type  = var.instance_type[var.cloud_provider]["monitoring"]
#   vm_count       = var.vm_count[var.cloud_provider]["monitoring"]
#   region         = var.region[var.cloud_provider]
#   ssh_key        = var.ssh_key
#   network_id     = module.network.network_id
#   firewall_id = module.network.firewall_id
# }
