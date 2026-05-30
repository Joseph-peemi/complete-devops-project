terraform {
  required_providers {
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = "0.4.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

provider "minikube" {
  kubernetes_version = "v1.30.1"
}

resource "minikube_cluster" "minikube_docker" {
  driver       = "docker"
  cluster_name = "complete-devops-project"
  addons = [
    "default-storageclass",
    "storage-provisioner"
  ]
}
