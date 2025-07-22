variable "region" {
  default = "us-east-1"
}

variable "project" {
  default = "todo-app"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_az2_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.3.0/24"
}

variable "private_subnet_az2_cidr" {
  default = "10.0.4.0/24"
}
variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  default     = "ami-020cba7c55df1f615" # Example AMI ID, replace with your desired AMI

}

variable "key_name" {
  description = "SSH key pair name for EC2 instances"
  default     = "my-key-pair" # Replace with your SSH key pair name

}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro" # Example instance type, adjust as needed

}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "todoapp"

}

variable "db_username" {
  description = "DB username"
  type        = string
  default     = "postgres"

}
variable "db_password" {
  description = "DB password must be at least 8 characters long"
  type        = string
  sensitive   = true

}
