resource "azurerm_public_ip" "web_pip" {
  count               = var.web_node_count
  name                = "lab2-web-pip-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "web_nic" {
  count               = var.web_node_count
  name                = "lab2-web-nic-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_pip[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "web" {
  count               = var.web_node_count
  name                = "vladyslav-kotsiuba-im52mp-web${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = var.machine_type

  admin_username                  = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.web_nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/id_rsa.pub")
  }

  custom_data = base64encode(templatefile("${path.module}/scripts/init_web.sh", {
    db_password   = var.db_password
    student_name  = var.student_name
    primary_db_ip = azurerm_network_interface.db_nic[0].ip_configuration[0].private_ip_address
  }))

  depends_on = [azurerm_linux_virtual_machine.db]
}
