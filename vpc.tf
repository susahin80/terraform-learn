provider "aws" {
  region = "eu-central-1"
}

variable "vpc_cidr_block" {}
variable "private_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}

data "aws_availability_zones" "azs" {}

module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"


  name            = "myapp-vpc"
  cidr            = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks
  azs             = data.aws_availability_zones.azs.names # ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

  enable_nat_gateway = true
  /* enable_vpn_gateway = true */
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/my-demo-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/my-demo-cluster" = "shared"
    "kubernetes.io/role/elb"           = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/my-demo-cluster" = "shared"
    "kubernetes.io/role/internal-elb"  = 1
  }

}
