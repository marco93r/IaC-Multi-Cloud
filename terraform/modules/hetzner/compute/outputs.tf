output "vm_ips" {
  value = hcloud_server.vm[*].ipv4_address
}
