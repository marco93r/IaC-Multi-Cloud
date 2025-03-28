module "cloud" {
  source         = "./modules/cloud/${var.cloud_provider}"
  cloud_provider = var.cloud_provider
  region         = var.region[var.cloud_provider]
  ssh_key        = var.ssh_key
  ssh_key_path  = var.ssh_key_path
  instance_type  = var.instance_type[var.cloud_provider]
  vm_count       = var.vm_count[var.cloud_provider]
  extra_disks    = try(var.extra_disks[var.cloud_provider], [])
}