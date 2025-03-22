output "vm_ips" {
  value = aws_instance.vm[*].public_ip
}
