provider "aws" {
  region = "us-east-1"

}

#VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project}-vpc"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-igw"
  }
}

# Availability Zones Data Source
data "aws_availability_zones" "available" {}

# Two Public Subnets  
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-subnet"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-subnet-az2"
  }
}


# Two Private Subnets
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project}-private-subnet"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project}-private-subnet-az2"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project}-public-route-table"
  }
}

# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project}-ec2-sg"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP access"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project}-ec2-sg"

  }
}


# EC2 Instance
resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  depends_on = [
    aws_db_instance.postgres,            # Ensure RDS is created before EC2
    aws_db_subnet_group.db_subnet_group, # Ensure DB subnet group is created before EC2
    aws_security_group.ec2_sg            # Ensure security group is created before EC2

  ]
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install docker.io -y
              systemctl start docker
              systemctl enable docker
              
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              
              git clone https://github.com/koushik2316/Octa-Byte_Assement.git /home/ubuntu/todoapp
              cd /home/ubuntu/todoapp

              # Write .env file
              echo "DB_HOST=${aws_db_instance.postgres.address}" > .env
              echo "DB_PORT=5432" >> .env
              echo "DB_NAME=todoapp" >> .env
              echo "DB_USER=admin" >> .env
              echo "DB_PASSWORD=${var.db_password}" >> .env

              docker-compose up -d
              EOF
  tags = {
    Name = "${var.project}-app-instance"
  }
}

# RDS subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${var.project}-db-subnet-group"
  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.private_az2.id
  ]

  tags = {
    Name = "${var.project}-db-subnet-group"
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "${var.project}-rds-sg"
  description = "Allow PostgresSQL access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id] #only EC2 instances in the same security group can access RDS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-rds-sg"
  }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres" {
  identifier             = "${var.project}-postgres-db"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  skip_final_snapshot    = true

  tags = {
    Name = "${var.project}-rds"
  }
}

# Target Group for ALB
resource "aws_lb_target_group" "app_tg" {
  name        = "${var.project}-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "${var.project}-app-tg"
  }
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "Allow inbound HTTP access from internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP traffic from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project}-alb-sg"
  }
}

# Attaching EC2 instance to Target Group
resource "aws_lb_target_group_attachment" "app_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app.id
  port             = 5000

  depends_on = [
    aws_instance.app,          # Ensure EC2 instance is created before attaching to target group
    aws_lb_target_group.app_tg # Ensure target group is created before attachment
  ]
}

# Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = "${var.project}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public_az2.id]


  enable_deletion_protection = false

  tags = {
    Name = "${var.project}-alb"
  }
}

# Listener for ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
