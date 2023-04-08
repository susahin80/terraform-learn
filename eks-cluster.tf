/* terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
} */

/* provider "kubernetes" {
  host = data.aws_eks_cluster.myapp-cluster.endpoint #api server endpoint
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster#endpoint
  token                  = data.aws_eks_cluster_auth.myapp-cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "myapp-cluster" {
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest?tab=outputs
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "myapp-cluster" {
  name = module.eks.cluster_id
} */

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.12.0"

  cluster_name                   = "my-cluster"
  cluster_version                = "1.22"
  cluster_endpoint_public_access = true

  # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest?tab=outputs
  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id     = module.myapp-vpc.vpc_id

  tags = {
    environment = "development"
    application = "myapp"
  }

  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 2
      desired_size = 2

      instance_types = ["t2.small"]
    }
  }
}
