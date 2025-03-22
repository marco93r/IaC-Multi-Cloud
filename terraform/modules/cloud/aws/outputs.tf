output "management_server_ips" {
  value = module.management_server.vm_ips
}

output "k8s_master_ips" {
  value = module.k8s_master.vm_ips
}

output "k8s_worker_ips" {
  value = module.k8s_worker.vm_ips
}

output "storage_server_ips" {
  value = module.storage_server.vm_ips
}

output "monitoring_server_ips" {
  value = module.monitoring_server.vm_ips
}
