variable "aws_region" {
  default = "us-east-1"
}

variable "aws_account_id" {
  default = "627119595303"
}

variable "admin_iam_user" {
  default = "Abuchi"
}

variable "eks_admin_policy_arn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "cluster_name" {
  default = "complete-devops-project"
}

variable "cluster_version" {
  default = "1.30"
}

variable "vpc_name" {
  default = "complete-devops-project-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "node_instance_type" {
  default = "m7i-flex.large"
}
