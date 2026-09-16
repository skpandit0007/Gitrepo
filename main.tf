# 1. Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-devops-assignment"
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# 3. Subnet
resource "azurerm_subnet" "internal" {
  name                 = "snet-internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_cidr]
}

# 4. Dynamic Network Interfaces using for_each
resource "azurerm_network_interface" "nic" {
  for_each            = var.virtual_machines
  name                = "nic-${each.key}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# 5. Dynamic Linux Virtual Machines using for_each
resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.virtual_machines
  name                            = each.key
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = each.value.vm_size
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = each.value.disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = each.value.os_offer
    sku       = each.value.os_sku
    version   = "latest"
  }
}