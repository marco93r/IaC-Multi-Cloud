locals {
  aws_device_letters = ["f", "g", "h", "i", "j", "k", "l", "m", "n", "o"]
}

resource "aws_instance" "vm" {
  count         = var.vm_count
  ami           = "ami-03250b0e01c28d196"
  instance_type = var.instance_type
  key_name      = var.ssh_key
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  associate_public_ip_address = true

  tags = {
    Name = "${var.role}-${count.index}"
  }

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    ssh_key = var.ssh_key
    role    = var.role
  })
}

resource "aws_ebs_volume" "disk" {
  count             = length(var.extra_disks)
  availability_zone = "${var.region}a"
  size              = var.extra_disks[count.index].size
  type              = var.extra_disks[count.index].type
  tags = {
    Name = var.extra_disks[count.index].name
  }
}

resource "aws_volume_attachment" "attach" {
  count       = length(var.extra_disks)
  device_name = "/dev/sd${local.aws_device_letters[count.index]}"
  volume_id   = aws_ebs_volume.disk[count.index].id
  instance_id = aws_instance.vm[0].id

  depends_on = [ aws_instance.vm, aws_ebs_volume.disk ]
}
