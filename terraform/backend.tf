terraform {
  backend "s3" {
    bucket = "octabyte-terraform-state"
    key    = "todoapp/terraform.tfstate"
    region = "us-east-1"

  }
}
