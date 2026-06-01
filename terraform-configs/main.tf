# terraform {
#   required_providers {
#     minikube = {
#       source  = "scott-the-programmer/minikube"
#       version = "0.4.2"
#     }
#     helm = {
#       source  = "hashicorp/helm"
#       version = "~> 3.0"
#     }
#   }
# }

# provider "minikube" {
#   kubernetes_version = "v1.30.1"
# }

# resource "minikube_cluster" "minikube_docker" {
#   driver       = "docker"
#   cluster_name = "complete-devops-project"
#   addons = [
#     "default-storageclass",
#     "storage-provisioner"
#   ]
# }

# aws and helm providers are now defined in main.tf, so we can comment out the minikube provider and cluster resources from this file.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# EKS Cluster
module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "~> 20.0"
  cluster_name                             = var.cluster_name
  cluster_version                          = var.cluster_version
  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.private_subnets
  enable_irsa                              = true
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = [var.node_instance_type]
    }
  }
}

# VPC for EKS
module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "~> 5.0"
  name               = var.vpc_name
  cidr               = var.vpc_cidr
  azs                = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = true
}
