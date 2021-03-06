provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt = true
    region = "us-east-1"
  }
}

module "webserver_cluster" {
  source = "git::git@github.com:dsciacca/modules.git//services/webserver-cluster?ref=v0.0.1"

  cluster_name = "webservers-stage"
  db_remote_state_bucket = "terraform-up-and-running-state-dms"
  db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  max_size = 10
  min_size = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  from_port = 12345
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.webserver_cluster.elb_security_group_id
  to_port = 12345
  type = "ingress"
}