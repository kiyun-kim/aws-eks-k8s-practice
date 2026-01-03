terraform {
  backend "s3" {
    bucket       = "tf-state-s3-bucket-demo"
    key          = "staging/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
  }
}
