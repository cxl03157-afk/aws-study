data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix = var.study_name

  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  common_tags = {
    Project = var.study_name
  }
}

