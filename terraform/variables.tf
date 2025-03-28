
variable "cloud_provider" {
  description = "Aktiv gewählter Cloud Provider"
  type        = string
}

variable "region" {
  description = "Region je Provider"
  type        = map(string)
}

variable "ssh_key" {
  type = string
}

variable "ssh_key_path" {
  type = string
}

variable "vm_count" {
  description = "Anzahl VMs pro Rolle und Provider"
  type        = map(map(number))
}

variable "instance_type" {
  description = "Instanztypen je Rolle und Provider"
  type        = map(map(string))
}

variable "extra_disks" {
  description = "Zusätzliche Disks je Rolle für bestimmte Provider"
  type = map(list(object({
    name = string
    size = number
    type = string
  })))
  default = {}
}
