provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt = true
    region = "us-east-1"
  }
}

module "mysql" {
  source = "git::git@github.com:dsciacca/modules.git//data-stores/mysql?ref=v0.0.1"
  db_name = "example_database"
  db_username = "admin"
  instance_class = "db.t2.micro"
  allocated_storage = 10
  db_password = var.db_password
}
