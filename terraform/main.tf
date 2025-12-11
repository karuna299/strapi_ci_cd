terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# --------------------------------------------------
# DATA SOURCES
# --------------------------------------------------

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# --------------------------------------------------
# SECURITY GROUPS
# --------------------------------------------------

# EC2 SG
resource "aws_security_group" "ec2_sg" {
  name   = "karuna-ec2-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS SG → Only allow EC2
resource "aws_security_group" "rds_sg" {
  name   = "karuna-rds-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --------------------------------------------------
# RDS SUBNET GROUP
# --------------------------------------------------

resource "aws_db_subnet_group" "strapi_subnet" {
  name       = "karuna-strapi-subnet"
  subnet_ids = data.aws_subnets.default.ids
}

# --------------------------------------------------
# RDS INSTANCE
# --------------------------------------------------

resource "aws_db_instance" "karuna_strapi" {
  identifier             = var.db_identifier
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  port                   = 5432

  publicly_accessible    = false
  skip_final_snapshot    = true

  db_subnet_group_name   = aws_db_subnet_group.strapi_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

# --------------------------------------------------
# EC2 INSTANCE
# --------------------------------------------------

resource "aws_instance" "karuna_strapi_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = var.key_name

  iam_instance_profile        = var.existing_instance_profile

  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user-data.sh.tpl", {
    region      = var.region
    db_endpoint = aws_db_instance.karuna_strapi.address
    db_name     = var.db_name
    db_user     = var.db_username
    db_pass     = var.db_password
    ecr_image   = var.ecr_image
  })

  depends_on = [
    aws_db_instance.karuna_strapi
  ]

  tags = {
    Name = "Karunaissa-EC2"
  }
}
