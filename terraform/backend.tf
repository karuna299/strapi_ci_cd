terraform {
  backend "s3" {
    bucket         = "my-terraform-state-5"
    key            = "global/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}
