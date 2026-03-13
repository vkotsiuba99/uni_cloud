variable "machine_type" {
  description = "Azure VM size"
  default     = "Standard_B1s"
}

variable "db_password" {
  default = "TestUs3r4!DB"
}

variable "student_name" {
  default = "Vladyslav Kotsiuba IM-52mp"
}

variable "web_server_count" {
  description = "Number of web servers for horizontal scaling"
  default     = 2
}

variable "location" {
  description = "Azure region"
  default     = "northeurope"
}

variable "resource_group_name" {
  description = "Azure resource group name"
  default     = "uni-cloud-lab1-rg"
}
