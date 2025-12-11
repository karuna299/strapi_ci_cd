variable "region" { default = "ap-south-1" }

variable "ami_id" {
  description = "Ubuntu AMI (ap-south-1)"
  default     = "ami-087d1c9a513324697"
}

variable "instance_type" { default = "t2.micro" }
variable "key_name"       { default = "karuna-key" }

variable "existing_instance_profile" {
  description = "Use the existing EC2 IAM instance profile"
  default     = "strapi-ec2-role"   # <-- PUT EXACT NAME FROM AWS
}

variable "ecr_image" {
  default = "301782007642.dkr.ecr.ap-south-1.amazonaws.com/karunaissa-strapi:latest"
}

variable "db_identifier"     { default = "karuna-db" }
variable "db_name"           { default = "karunadb" }
variable "db_username"       { default = "Karunausr" }
variable "db_password"       { default = "Karuna3214" }
variable "db_instance_class" { default = "db.t3.micro" }