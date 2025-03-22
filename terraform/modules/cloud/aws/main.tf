module "network" {
  source         = "../../aws/network"
  cloud_provider = var.cloud_provider
  region         = var.region
}

module "management_server" {
  source           = "../../aws/compute"
  role             = "management"
  cloud_provider   = var.cloud_provider
  instance_type    = var.instance_type["management"]
  vm_count         = var.vm_count["management"]
  region           = var.region
  ssh_key          = var.ssh_key
  vpc_id           = module.network.vpc_id
  subnet_id        = module.network.subnet_id
  security_group_id = module.network.security_group_id
  extra_disks      = []
}

module "k8s_master" {
  source           = "../../aws/compute"
  role             = "k8s-master"
  cloud_provider   = var.cloud_provider
  instance_type    = var.instance_type["k8s_master"]
  vm_count         = var.vm_count["k8s_master"]
  region           = var.region
  ssh_key          = var.ssh_key
  vpc_id           = module.network.vpc_id
  subnet_id        = module.network.subnet_id
  security_group_id = module.network.security_group_id
  extra_disks      = []
}

module "k8s_worker" {
  source           = "../../aws/compute"
  role             = "k8s-worker"
  cloud_provider   = var.cloud_provider
  instance_type    = var.instance_type["k8s_worker"]
  vm_count         = var.vm_count["k8s_worker"]
  region           = var.region
  ssh_key          = var.ssh_key
  vpc_id           = module.network.vpc_id
  subnet_id        = module.network.subnet_id
  security_group_id = module.network.security_group_id
  extra_disks      = []
}

module "storage_server" {
  source           = "../../aws/compute"
  role             = "storage"
  cloud_provider   = var.cloud_provider
  instance_type    = var.instance_type["storage"]
  vm_count         = var.vm_count["storage"]
  region           = var.region
  ssh_key          = var.ssh_key
  vpc_id           = module.network.vpc_id
  subnet_id        = module.network.subnet_id
  security_group_id = module.network.security_group_id
  extra_disks      = var.extra_disks
}

module "monitoring_server" {
  source           = "../../aws/compute"
  role             = "monitoring"
  cloud_provider   = var.cloud_provider
  instance_type    = var.instance_type["monitoring"]
  vm_count         = var.vm_count["monitoring"]
  region           = var.region
  ssh_key          = var.ssh_key
  vpc_id           = module.network.vpc_id
  subnet_id        = module.network.subnet_id
  security_group_id = module.network.security_group_id
  extra_disks      = []
}
