variable "cloud_provider" {
  type = string
}

variable "region" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "instance_type" {
  type = map(string)
}

variable "vm_count" {
  type = map(number)
}

variable "extra_disks" {
  type = list(object({
    name = string
    size = number
    type = string
  }))
  default = []
}

# variable "hcloud_ssh_key_name" {
#   type = string
# }
