variable "machine_type" {
  description = "Azure VM size"
  default     = "Standard_B1s"
}

variable "student_name" {
  default = "Vladyslav Kotsiuba IM-52mp"
}

variable "location" {
  description = "Azure region"
  default     = "northeurope"
}

variable "resource_group_name" {
  description = "Azure resource group name"
  default     = "uni-cloud-lab3-rg"
}
