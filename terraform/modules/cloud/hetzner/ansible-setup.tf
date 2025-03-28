# Upload SSH-Key auf den Management-Server
resource "null_resource" "upload_ssh_key" {
  provisioner "file" {
    source      = "~/.ssh/id_ed25519"
    destination = "/home/adminuser/.ssh/id_ed25519"
  }

  connection {
    type        = "ssh"
    user        = "adminuser"
    private_key = file("~/.ssh/id_ed25519")
    host        = module.management_server.vm_ips[0]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/adminuser/.ssh/id_ed25519",
      "chown adminuser:adminuser /home/adminuser/.ssh/id_ed25519"
    ]
  }

  depends_on = [module.management_server]
}

resource "null_resource" "prepare_management_server" {
  provisioner "remote-exec" {
    inline = [ 
      "sudo apt-get update",
      "sudo apt-get install -y ansible",
      "rm -rf /home/adminuser/playbooks",
      "mkdir -p /home/adminuser/playbooks"
     ]

     connection {
       type = "ssh"
       user = "adminuser"
       private_key = file("~/.ssh/id_ed25519")
       host = module.management_server.vm_ips[0]
     }
  }
  depends_on = [ module.management_server ]
}

# Generiere Ansible Inventory
resource "local_file" "inventory" {
  filename = "${path.root}/ansible/inventory.ini"
  content = templatefile("${path.root}/ansible/inventory.tpl", {
    k8s_master_ip         = module.k8s_master.vm_ips
    k8s_worker_ip         = module.k8s_worker.vm_ips
    persistent_storage_ip = module.storage_server.vm_ips
    monitoring_logging_ip = module.monitoring_server.vm_ips
    ssh_key_path = pathexpand(var.ssh_key_path)
  })

  depends_on = [module.management_server, module.k8s_master, module.k8s_worker, module.storage_server, module.monitoring_server, null_resource.prepare_management_server]
}

# Lade Inventory hoch
resource "null_resource" "upload_inventory" {
  provisioner "file" {
    source      = local_file.inventory.filename
    destination = "/home/adminuser/inventory.ini"
  }

  connection {
    type        = "ssh"
    user        = "adminuser"
    private_key = file("~/.ssh/id_ed25519")
    host        = module.management_server.vm_ips[0]
  }

  depends_on = [local_file.inventory, null_resource.prepare_management_server]
}

# Lade Playbooks hoch
resource "null_resource" "upload_playbooks" {
  provisioner "file" {
    source      = "${path.root}/ansible/playbooks"
    destination = "/home/adminuser"
  }

  connection {
    type        = "ssh"
    user        = "adminuser"
    private_key = file("~/.ssh/id_ed25519")
    host        = module.management_server.vm_ips[0]
  }

  depends_on = [null_resource.upload_inventory, null_resource.prepare_management_server]
}

# Führe Ansible-Playbooks aus
resource "null_resource" "run_ansible" {
  provisioner "remote-exec" {
    inline = [
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      "ansible-playbook -i /home/adminuser/inventory.ini /home/adminuser/playbooks/setup_persistent_storage_${var.cloud_provider}.yml",
      "ansible-playbook -i /home/adminuser/inventory.ini /home/adminuser/playbooks/setup_grafana_prometheus.yml",
      # "ANSIBLE_SSH_ARGS='-o StrictHostKeyChecking=no' ansible-playbook -i /home/adminuser/inventory.ini /home/adminuser/playbooks/configure_prometheus.yml",
      # "ANSIBLE_SSH_ARGS='-o StrictHostKeyChecking=no' ansible-playbook -i /home/adminuser/inventory.ini /home/adminuser/playbooks/configure_grafana.yml",
      # "ANSIBLE_SSH_ARGS='-o StrictHostKeyChecking=no' ansible-playbook -i /home/adminuser/inventory.ini /home/adminuser/playbooks/configure_k8s-cluster.yml",
      # "ANSIBLE_SSH_ARGS='-o StrictHostKeyChecking=no' ansible-playbook -i /home/adminuser/inventory.ini /home/adminuser/playbooks/configure_k8s-master.yml",
      # "ANSIBLE_SSH_ARGS='-o StrictHostKeyChecking=no' ansible-playbook -i /home/adminuser/inventory.ini /home/adminuser/playbooks/configure_k8s-worker.yml",
      # "ANSIBLE_SSH_ARGS='-o StrictHostKeyChecking=no' ansible-playbook -i /home/adminuser/inventory.ini /home/adminuser/playbooks/provision_persistent-storage-k8s.yml",
      # "ANSIBLE_SSH_ARGS='-o StrictHostKeyChecking=no' ansible-playbook -i /home/adminuser/inventory.ini /home/adminuser/playbooks/provision_wordpress.yml"
    ]
  }

  connection {
    type        = "ssh"
    user        = "adminuser"
    private_key = file("~/.ssh/id_ed25519")
    host        = module.management_server.vm_ips[0]
  }

  depends_on = [null_resource.upload_playbooks, null_resource.upload_inventory, null_resource.prepare_management_server]
}
