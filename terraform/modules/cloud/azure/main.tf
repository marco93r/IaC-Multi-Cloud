module "network" {
  source         = "../../azure/network"
  cloud_provider = var.cloud_provider
  region         = var.region
}

module "management_server" {
  source              = "../../azure/compute"
  role                = "management"
  cloud_provider      = var.cloud_provider
  instance_type       = var.instance_type["management"]
  vm_count            = var.vm_count["management"]
  region              = var.region
  ssh_key             = var.ssh_key
  subnet_id           = module.network.subnet_id
  resource_group_name = module.network.resource_group_name
  nsg_id              = module.network.nsg_id
  extra_disks         = var.extra_disks
}

module "k8s_master" {
  source              = "../../azure/compute"
  role                = "k8s-master"
  cloud_provider      = var.cloud_provider
  instance_type       = var.instance_type["k8s_master"]
  vm_count            = var.vm_count["k8s_master"]
  region              = var.region
  ssh_key             = var.ssh_key
  subnet_id           = module.network.subnet_id
  resource_group_name = module.network.resource_group_name
  nsg_id              = module.network.nsg_id
  extra_disks         = []
}

module "k8s_worker" {
  source              = "../../azure/compute"
  role                = "k8s-worker"
  cloud_provider      = var.cloud_provider
  instance_type       = var.instance_type["k8s_worker"]
  vm_count            = var.vm_count["k8s_worker"]
  region              = var.region
  ssh_key             = var.ssh_key
  subnet_id           = module.network.subnet_id
  resource_group_name = module.network.resource_group_name
  nsg_id              = module.network.nsg_id
  extra_disks         = []
}

module "storage_server" {
  source              = "../../azure/compute"
  role                = "storage"
  cloud_provider      = var.cloud_provider
  instance_type       = var.instance_type["storage"]
  vm_count            = var.vm_count["storage"]
  region              = var.region
  ssh_key             = var.ssh_key
  subnet_id           = module.network.subnet_id
  resource_group_name = module.network.resource_group_name
  nsg_id              = module.network.nsg_id
  extra_disks         = var.extra_disks
}

module "monitoring_server" {
  source              = "../../azure/compute"
  role                = "monitoring"
  cloud_provider      = var.cloud_provider
  instance_type       = var.instance_type["monitoring"]
  vm_count            = var.vm_count["monitoring"]
  region              = var.region
  ssh_key             = var.ssh_key
  subnet_id           = module.network.subnet_id
  resource_group_name = module.network.resource_group_name
  nsg_id              = module.network.nsg_id
  extra_disks         = []
}
