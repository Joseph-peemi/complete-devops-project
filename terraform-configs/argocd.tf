resource "helm_release" "argocd" {
  depends_on       = [module.eks]
  name             = "argocd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "7.7.0"
  namespace        = "argocd"
  create_namespace = true
  timeout          = 600

  values = [
    <<EOF
    server:
      service:
        type: ClusterIP
    EOF
  ]
}