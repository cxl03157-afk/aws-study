variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "study_name" {
  type    = string
  default = "aws-study"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "ec2_key_name" {
  type    = string
  default = "aws-study-kye3"
}

variable "ec2_ssh_cidr" {
  type    = string
  default = "106.73.130.193/32"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
