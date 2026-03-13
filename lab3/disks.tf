resource "azurerm_managed_disk" "disk1" {
  count               = 2
  name                = "vladyslav-kotsiuba-im52mp-disk1-node${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 2
}

resource "azurerm_managed_disk" "disk2" {
  count               = 2
  name                = "vladyslav-kotsiuba-im52mp-disk2-node${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 2
}

resource "azurerm_virtual_machine_data_disk_attachment" "stor_disk1_attach" {
  count              = 2
  managed_disk_id    = azurerm_managed_disk.disk1[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.stor[count.index].id
  lun                = 0
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_data_disk_attachment" "stor_disk2_attach" {
  count              = 2
  managed_disk_id    = azurerm_managed_disk.disk2[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.stor[count.index].id
  lun                = 1
  caching            = "ReadWrite"
}
