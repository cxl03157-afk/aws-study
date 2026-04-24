# backendの定義
terraform {
  backend "s3" {
    bucket         = "tf-aws-study"
    key            = "terraform-webapp-monitoring/dev/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
