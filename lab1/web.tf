resource "azurerm_network_interface" "web_nic" {
  count               = var.web_server_count
  name                = "lab1-web-nic-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "web" {
  count               = var.web_server_count
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
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/id_rsa.pub")
  }

  custom_data = base64encode(templatefile("${path.module}/scripts/startup-go.sh.tmpl", {
    stage                  = "Lab 1"
    enable_mysql_router    = "false" # Роутер буде у 2 лабі
    enable_storage_stack   = "false" # Сховище буде у 3 лабі
    node_name              = "vladyslav-kotsiuba-im52mp-web${count.index + 1}"
    node_private_ip        = azurerm_network_interface.web_nic[count.index].private_ip_address
    peer_private_ip        = ""
    gluster_primary        = "false"
    gluster_volume_name    = "vol0"
    gluster_brick_path     = "/mnt/brick"
    shared_mount_path      = "/mnt/shared"
    disk_device_a          = ""
    disk_device_b          = ""
    go_version             = "1.22.1"
    app_port               = "8080"
    mysql_router_rw_port   = "6446"
    mysql_router_ro_port   = "6447"
    cluster_primary_ip     = ""
    cluster_admin_user     = ""
    cluster_admin_password = ""
    db_host                = azurerm_network_interface.db_nic.private_ip_address # Пряме підключення до БД
    db_port                = "3306"
    db_read_port           = "3306"
    db_name                = "appdb"
    db_user                = "app_user"
    db_password            = var.db_password
  }))

  depends_on = [azurerm_linux_virtual_machine.db]
}
