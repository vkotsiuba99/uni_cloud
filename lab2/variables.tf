variable "machine_type" {
  description = "Azure VM size"
  default     = "Standard_B1s"
}
variable "db_password" { default = "TestUs3r4!DB" }
variable "student_name" { default = "Vladyslav Kotsiuba IM-52mp" }
variable "db_node_count" { default = 3 }
variable "web_node_count" { default = 2 }

variable "location" {
  description = "Azure region"
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Azure resource group name"
  default     = "uni-cloud-lab2-rg"
}
