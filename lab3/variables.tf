variable "machine_type" {
  description = "Azure VM size"
  default     = "Standard_F1as_v7"
}

variable "student_name" {
  default = "Vladyslav Kotsiuba IM-52mp"
}

variable "location" {
  description = "Azure region"
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Azure resource group name"
  default     = "uni-cloud-lab3-rg"
}
