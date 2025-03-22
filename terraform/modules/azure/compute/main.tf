resource "azurerm_public_ip" "pip" {
  count               = var.vm_count
  name                = "${var.role}-pip-${count.index}"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.role}-nic-${count.index}"
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "nsg" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = var.nsg_id
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = replace("${var.role}-${count.index}", "_", "-")
  location            = var.region
  resource_group_name = var.resource_group_name
  size                = var.instance_type
  admin_username      = "adminuser"

  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.ssh_key)
  }

  disable_password_authentication = true
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    name              = "${var.role}-osdisk-${count.index}"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_managed_disk" "disk" {
  count               = length(var.extra_disks)
  name                = "${var.role}-disk-${count.index}"
  location            = var.region
  resource_group_name = var.resource_group_name
  storage_account_type = var.extra_disks[count.index].type
  create_option       = "Empty"
  disk_size_gb        = var.extra_disks[count.index].size
}

resource "azurerm_virtual_machine_data_disk_attachment" "attach" {
  count              = length(var.extra_disks)
  managed_disk_id    = azurerm_managed_disk.disk[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.vm[0].id
  lun                = count.index
  caching            = "ReadWrite"
}
