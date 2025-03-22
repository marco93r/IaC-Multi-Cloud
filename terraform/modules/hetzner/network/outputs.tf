output "network_id" {
  value = hcloud_network.net.id
}

output "firewall_id" {
  value = hcloud_firewall.default.id
}
