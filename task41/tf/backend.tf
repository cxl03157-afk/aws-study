# backendの定義、lock追加
terraform {
  backend "s3" {
    bucket         = "tf-aws-study"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-lock"
  }
}
