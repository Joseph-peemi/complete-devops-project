# AWS EKS GitOps Pipeline with Terraform & ArgoCD

End-to-end **GitOps** pipeline on AWS EKS featuring a Python/Flask application, infrastructure provisioned with Terraform, container images pushed to Amazon ECR, and continuous deployment using ArgoCD.

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![ArgoCD](https://img.shields.io/badge/ArgoCD-%231A1A1A.svg?style=for-the-badge&logo=argo&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-%232088FF.svg?style=for-the-badge&logo=github-actions&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

## Overview

This project demonstrates a complete production-ready DevOps workflow on AWS:

- **Infrastructure as Code**: VPC, EKS cluster, and supporting resources using Terraform
- **Application**: Python Flask app containerized with Docker
- **CI**: GitHub Actions for building and pushing images to Amazon ECR
- **GitOps**: ArgoCD for declarative, automated deployments on EKS
- **Monitoring**: Prometheus, Alertmanager, and Grafana

## Project Structure
.
├── complete-devops-project-time-printer/   # Flask application source
├── terraform-configs/                      # Terraform infrastructure
├── .github/workflows/                      # GitHub Actions CI pipeline
├── argocd-app.yaml                         # ArgoCD Application manifest
├── Dockerfile
├── docker-compose.yml
├── prometheus.yml
├── alertmanager.yml
├── alertrules.yml
├── values.yaml
└── ...
text## Tech Stack

| Layer              | Technology                          |
|--------------------|-------------------------------------|
| Application        | Python + Flask                      |
| Container          | Docker                              |
| CI/CD              | GitHub Actions                      |
| IaC                | Terraform                           |
| Cluster            | AWS EKS                             |
| Registry           | Amazon ECR                          |
| GitOps             | ArgoCD                              |
| Observability      | Prometheus + Grafana                |
| State Backend      | Amazon S3                           |

## Prerequisites

- AWS account with admin permissions
- AWS CLI configured
- Terraform ≥ 1.5
- kubectl
- Helm (optional)

## Getting Started

### 1. Terraform Backend

Create an S3 bucket for Terraform state:

```bash
aws s3 mb s3://your-unique-terraform-state-bucket --region us-east-1
Update the backend configuration in terraform-configs/backend.tf.

2. Provision Infrastructure
Bash
cd terraform-configs
terraform init
terraform plan -out=tfplan
terraform apply tfplan

3. Connect to EKS Cluster
Bash
aws eks update-kubeconfig --region us-east-1 --name complete-devops-project
kubectl get nodes

4. Access ArgoCD
Bash
kubectl port-forward svc/argocd-server -n argocd 8081:443

URL: http://localhost:8081
Username: admin
Password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

5. Deploy Application
Bash
kubectl apply -f argocd-app.yaml
GitHub Actions will automatically build new images and update the deployment via GitOps.
Required GitHub Secrets


Secret                 Description
AWS_ACCESS_KEY_ID      IAM user access key
AWS_SECRET_ACCESS_KEY  IAM user secret key
Features

Full Infrastructure as Code with Terraform
Automated container builds and ECR pushes via GitHub Actions
GitOps continuous deployment with ArgoCD
Production-grade EKS cluster setup
Built-in monitoring stack
Secure Terraform state in S3
