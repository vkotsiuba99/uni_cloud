resource "azurerm_network_interface" "db_nic" {
  name                = "lab1-db-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "db" {
  name                = "vladyslav-kotsiuba-im52mp-db"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = var.machine_type

  admin_username                  = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.db_nic.id,
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

  custom_data = base64encode(templatefile("${path.module}/scripts/startup-mysql.sh.tmpl", {
    cluster_mode             = "false" # Для 1 лаби кластер вимкнено
    node_role                = "primary"
    node_private_ip          = azurerm_network_interface.db_nic.private_ip_address
    node_server_id           = "1"
    stage                    = "Lab 1"
    subnet_cidr              = "10.0.0.0/24" # Або інший, якщо у тебе змінений префікс підмережі
    cluster_seed_list        = ""
    cluster_primary_ip       = ""
    cluster_secondary_ips    = ""
    cluster_name             = ""
    cluster_group_uuid       = ""
    cluster_admin_user       = ""
    cluster_admin_password   = ""
    db_name                  = "appdb"
    db_user                  = "app_user"
    db_password              = var.db_password
    mysql_shell_download_url = "https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-8.0.36-linux-glibc2.28-x86-64bit.tar.gz"
  }))
}
