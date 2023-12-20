provider "azurerm" {
  features {}
}

# refer to a resource group
data "azurerm_resource_group" "test" {
  name = "atlas-pool_group"
}

#refer to a subnet
data "azurerm_subnet" "test" {
  name                 = "default"
  virtual_network_name = "tutu"
  resource_group_name  = "atlas-pool_group"
}

# Create public IPs
resource "azurerm_public_ip" "test" {
    name                = "myPublicIP"
    location            = data.azurerm_resource_group.test.location
    resource_group_name = data.azurerm_resource_group.test.name
    allocation_method   = "Dynamic"

}

# create a network interface
resource "azurerm_network_interface" "test" {
  name                = "nic-test"
  location            = "${data.azurerm_resource_group.test.location}"
  resource_group_name = "${data.azurerm_resource_group.test.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${data.azurerm_subnet.test.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.test.id}"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "myvm"
  location              = data.azurerm_resource_group.test.location
  resource_group_name   = data.azurerm_resource_group.test.name
  network_interface_ids = [azurerm_network_interface.test.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_profile {
    computer_name  = "myvm"
    admin_username = "superuser"
    admin_password = "Admin-456"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "ansible"
  }
}

# Add this to your existing Terraform configuration
resource "null_resource" "ansible_provisioner" {
  provisioner "local-exec" {
    command     = <<-EOT
      ansible-playbook -i ${azurerm_network_interface.test.private_ip_addresses[0]}, test.yml
      ansible-playbook -i ${azurerm_network_interface.test.private_ip_addresses[0]}, create.yml
      ansible-playbook -i ${azurerm_network_interface.test.private_ip_addresses[0]}, apache.yml
    EOT
    working_dir = "${path.module}/playbook"
  }

  depends_on = [azurerm_virtual_machine.vm]
}
