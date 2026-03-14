resource "azurerm_public_ip" "lb_pip" {
  name                = "lab1-lb-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "lb_nic" {
  name                = "lab1-lb-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "lb" {
  name                = "vladyslav-kotsiuba-im52mp-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = var.machine_type

  admin_username                  = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.lb_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/id_rsa.pub")
  }

  custom_data = base64encode(templatefile("${path.module}/scripts/startup-nginx.sh.tmpl", {
    app_upstreams = azurerm_network_interface.web_nic[*].private_ip_address
    app_port      = "8080"
  }))

  depends_on = [azurerm_linux_virtual_machine.web]
}
