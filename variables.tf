variable "common_tags" {
  type    = map
  default = {
    Env         = "Dev"
    Departament = "Finance"
  }
}

variable "my_ip_cidr" {}

variable "default_vpc_id" {}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {}

variable "ssh_pub_key_path" {}
