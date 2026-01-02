terraform {
  backend "s3" {
    bucket       = "terraform-s3-backend-curry"
    key          = "stg/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
  }
}
