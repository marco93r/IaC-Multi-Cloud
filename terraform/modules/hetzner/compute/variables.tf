variable "role" {
  type = string
}

variable "cloud_provider" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "vm_count" {
  type = number
}

variable "region" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "network_id" {
  type = string
}

variable "extra_disks" {
  type = list(object({
    name = string
    size = number
    type = string
  }))
  default = []
}

variable "firewall_id" {
  type = string
}

