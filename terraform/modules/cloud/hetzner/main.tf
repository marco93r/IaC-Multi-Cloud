module "network" {
  source         = "../../hetzner/network"
  cloud_provider = var.cloud_provider
  region         = var.region
}

module "management_server" {
  source           = "../../hetzner/compute"
  role             = "management"
  cloud_provider   = var.cloud_provider
  instance_type    = var.instance_type["management"]
  vm_count         = var.vm_count["management"]
  region           = var.region
  ssh_key          = var.ssh_key
  network_id       = module.network.network_id
  firewall_id      = module.network.firewall_id
  extra_disks      = []
  #hcloud_ssh_key_name = var.hcloud_ssh_key_name
}

module "k8s_master" {
  source           = "../../hetzner/compute"
  role             = "k8s-master"
  cloud_provider   = var.cloud_provider
  instance_type    = var.instance_type["k8s_master"]
  vm_count         = var.vm_count["k8s_master"]
  region           = var.region
  ssh_key          = var.ssh_key
  network_id       = module.network.network_id
  firewall_id      = module.network.firewall_id
  extra_disks      = []
  #hcloud_ssh_key_name = var.hcloud_ssh_key_name
}

module "k8s_worker" {
  source           = "../../hetzner/compute"
  role             = "k8s-worker"
  cloud_provider   = var.cloud_provider
  instance_type    = var.instance_type["k8s_worker"]
  vm_count         = var.vm_count["k8s_worker"]
  region           = var.region
  ssh_key          = var.ssh_key
  network_id       = module.network.network_id
  firewall_id      = module.network.firewall_id
  extra_disks      = []
  #hcloud_ssh_key_name = var.hcloud_ssh_key_name
}

module "storage_server" {
  source           = "../../hetzner/compute"
  role             = "storage"
  cloud_provider   = var.cloud_provider
  instance_type    = var.instance_type["storage"]
  vm_count         = var.vm_count["storage"]
  region           = var.region
  ssh_key          = var.ssh_key
  network_id       = module.network.network_id
  firewall_id      = module.network.firewall_id
  extra_disks      = var.extra_disks
  #hcloud_ssh_key_name = var.hcloud_ssh_key_name
}

module "monitoring_server" {
  source           = "../../hetzner/compute"
  role             = "monitoring"
  cloud_provider   = var.cloud_provider
  instance_type    = var.instance_type["monitoring"]
  vm_count         = var.vm_count["monitoring"]
  region           = var.region
  ssh_key          = var.ssh_key
  network_id       = module.network.network_id
  firewall_id      = module.network.firewall_id
  extra_disks      = []
  #hcloud_ssh_key_name = var.hcloud_ssh_key_name
}
