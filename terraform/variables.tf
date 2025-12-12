variable "region" { default = "ap-south-1" }

variable "ami_id" {
  description = "Ubuntu AMI (ap-south-1)"
  default     = "ami-087d1c9a513324697"
}

variable "instance_type" { default = "t2.micro" }
variable "key_name"       { default = "kkey-vot" }

variable "ecr_image" {
  default = "713881818561.dkr.ecr.ap-south-1.amazonaws.com/karuna-strapi:latest"
}

variable "db_identifier"     { default = "karuna-db" }
variable "db_name"           { default = "karunadb" }
variable "db_username"       { default = "Karunausr" }
variable "db_password"       { default = "Karuna3214" }
variable "db_instance_class" { default = "db.t3.micro" }

variable "admin_jwt_secret" { default = "mySuperSecretJWTString123!" }
variable "api_token_salt"   { default = "anotherRandomString456!" }

# New required variable for Strapi
variable "app_keys" {
  description = "Comma-separated APP_KEYS for Strapi"
  default     = "Xg3k2t9fF9Y8q1pR,aQ5u1xH2sD7h8JkL,ZpL7bR2mTqW9eXyV,Gh7S4cFpD2rQ1sKj"
}
