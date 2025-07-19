variable "name_prefix" {
  description = "The prefix to use for all resources in this module."
  type        = string

}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)

}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)

}

variable "availability_zones" {
  description = "List of availability zones to use for the VPC."
  type        = list(string)

}
