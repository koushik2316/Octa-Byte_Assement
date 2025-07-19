provider "aws" {
  region = var.aws_region

}

module "vpc" {
  source             = "./modules/vpc"
  name_prefix        = var.name_prefix
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones

}
