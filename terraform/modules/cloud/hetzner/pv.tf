resource "local_file" "persistent_volume_yaml" {
  content = templatefile("${path.root}/ansible/pv.tftpl", {
    nfs_server_disk1 = module.storage_server.vm_ips[0]
    nfs_server_disk2 = module.storage_server.vm_ips[0]
  })

  filename = "${path.module}/pv.yaml"
  depends_on = [module.storage_server]
}

resource "null_resource" "transfer_pv_yaml" {
  depends_on = [local_file.persistent_volume_yaml, module.management_server]

  provisioner "file" {
    source      = local_file.persistent_volume_yaml.filename
    destination = "/home/adminuser/pv.yaml"

    connection {
      type        = "ssh"
      user        = "adminuser"
      private_key = file("~/.ssh/id_ed25519")
      host        = module.management_server.vm_ips[0]
    }
  }
}
