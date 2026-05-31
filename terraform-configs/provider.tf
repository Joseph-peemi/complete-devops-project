# provider "kubernetes" {
#   host                   = minikube_cluster.minikube_docker.host
#   client_certificate     = minikube_cluster.minikube_docker.client_certificate
#   client_key             = minikube_cluster.minikube_docker.client_key
#   cluster_ca_certificate = minikube_cluster.minikube_docker.cluster_ca_certificate
# }

# provider "helm" {
#   kubernetes = {
#     config_path = "~/.kube/config"
#   }

# }
# using the helm provider with EKS requires a different configuration, so we will comment out the previous helm provider configuration and add a new one that uses the EKS cluster information.
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}
