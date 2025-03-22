# data "hcloud_ssh_key" "default" {
#   name = var.hcloud_ssh_key_name
# }

resource "hcloud_server" "vm" {
  count       = var.vm_count
  name = replace("${var.role}-${count.index}", "_", "-")
  server_type = var.instance_type
  image       = "ubuntu-24.04"
  location    = var.region
  ssh_keys    = [var.ssh_key]
  firewall_ids = [var.firewall_id]
  user_data   = templatefile("${path.module}/cloud-init.yaml", {
    ssh_key = var.ssh_key
  })

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  network {
    network_id = var.network_id
  }
}

resource "hcloud_volume" "disk" {
  count    = length(var.extra_disks)
  name     = "${var.role}-disk-${count.index}"
  size     = var.extra_disks[count.index].size
  location = var.region
}


resource "hcloud_volume_attachment" "attach" {
  count     = length(var.extra_disks)
  volume_id = hcloud_volume.disk[count.index].id
  server_id = hcloud_server.vm[0].id
  automount = false
}
