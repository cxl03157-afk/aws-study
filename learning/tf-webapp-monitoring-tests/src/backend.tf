# backendの定義
terraform {
  backend "s3" {
    bucket = "tf-aws-study"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}
