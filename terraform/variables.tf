variable "aws_region" {
  description = "The AWS region where the VPC will be created."
  default     = "us-east-1"


}

variable "name_prefix" {
  description = "The prefix to use for all resources in this module."
  default     = "octabyte"

}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"

}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  default     = ["10.0.101.0/24", "10.0.102.0/24"]

}

variable "availability_zones" {
  description = "List of availability zones for the VPC."
  default     = ["us-east-1a", "us-east-1b"]

}

