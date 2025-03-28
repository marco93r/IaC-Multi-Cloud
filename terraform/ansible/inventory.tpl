[k8s_masters]
%{ for ip in k8s_master_ip }
${ip} ansible_user=adminuser ansible_host=${ip} ansible_ssh_private_key_file=${ssh_key_path} ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
%{ endfor }

[k8s_workers]
%{ for ip in k8s_worker_ip }
${ip} ansible_user=adminuser ansible_host=${ip} ansible_ssh_private_key_file=${ssh_key_path} ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
%{ endfor }

[persistent_storage]
%{ for ip in persistent_storage_ip }
${ip} ansible_user=adminuser ansible_host=${ip} ansible_ssh_private_key_file=${ssh_key_path} ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
%{ endfor }

[monitoring_logging]
%{ for ip in monitoring_logging_ip }
${ip} ansible_user=adminuser ansible_host=${ip} ansible_ssh_private_key_file=${ssh_key_path} ansible_ssh_extra_args='-o StrictHostKeyChecking=no'
%{ endfor }
