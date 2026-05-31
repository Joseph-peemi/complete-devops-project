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
  region = "us-east-1"
}

# EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = "complete-devops-project"
  cluster_version = "1.30"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  enable_irsa                    = true
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 2
      desired_size = 1
      instance_types = ["t3.medium"]
    }
  }
}

# VPC for EKS
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
  name    = "complete-devops-project-vpc"
  cidr    = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway = true
}
