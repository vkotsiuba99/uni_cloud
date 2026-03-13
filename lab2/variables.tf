variable "project_id" {
  description = "ID of your project in GCP"
  type        = string
}

variable "region" { default = "us-central1" }
variable "zone" { default = "us-central1-a" }
variable "machine_type" { default = "e2-micro" }
variable "db_password" { default = "TestUs3r4!DB" }
variable "student_name" { default = "Vladyslav Kotsiuba IM-52mp" }
variable "db_node_count" { default = 3 }
variable "web_node_count" { default = 2 }
