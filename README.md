# AWS EKS GitOps Pipeline with Terraform & ArgoCD

End-to-end **GitOps** pipeline on AWS EKS featuring a Python/Flask application, infrastructure-as-code with Terraform, container builds pushed to Amazon ECR, and continuous deployment using ArgoCD.

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![ArgoCD](https://img.shields.io/badge/ArgoCD-%231A1A1A.svg?style=for-the-badge&logo=argo&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-%232088FF.svg?style=for-the-badge&logo=github-actions&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

## Overview

This project demonstrates a complete production-ready DevOps workflow:

- **Infrastructure**: Provisioned with Terraform (VPC, EKS cluster, and supporting resources)
- **Application**: Python Flask app containerized with Docker
- **CI/CD**: GitHub Actions for building and pushing container images to Amazon ECR
- **GitOps**: ArgoCD for declarative deployments on AWS EKS
- **Observability**: Prometheus + Alertmanager + Grafana
- **State Management**: Terraform backend on Amazon S3

## Project Structure
├── complete-devops-project-time-printer/   # Flask application
├── terraform-configs/                      # Terraform IaC
├── .github/workflows/                      # GitHub Actions CI pipeline
├── argocd-app.yaml                         # ArgoCD Application definition
├── Dockerfile
├── docker-compose.yml
├── prometheus.yml
├── alertmanager.yml
├── alertrules.yml
└── ...


## Tech Stack

| Layer              | Technology                          |
|--------------------|-------------------------------------|
| Application        | Python + Flask                      |
| Container          | Docker                              |
| CI/CD              | GitHub Actions                      |
| IaC                | Terraform                           |
| Cluster            | AWS EKS                             |
| Registry           | Amazon ECR                          |
| GitOps             | ArgoCD                              |
| Observability      | Prometheus, Alertmanager, Grafana   |
| State Backend      | AWS S3                              |

## Prerequisites

- AWS account with appropriate permissions
- AWS CLI configured
- Terraform >= 1.5
- kubectl
- Helm
- ArgoCD CLI (optional but recommended)

## Getting Started

### 1. Terraform State Backend

Create an S3 bucket for Terraform state:

```bash
aws s3 mb s3://your-unique-terraform-state-bucket --region us-east-1
Update backend.tf with your bucket name.
2. Provision Infrastructure
cd terraform-configs
terraform init
terraform plan -out=tfplan
terraform apply tfplan

This creates:

VPC with public/private subnets
AWS EKS cluster with managed node groups
ArgoCD (via Helm)

3. Connect to the Cluster
aws eks update-kubeconfig --region us-east-1 --name complete-devops-project
kubectl get nodes
4. Access ArgoCD UI
Open http://localhost:8081 (can also use LB)
Default username: admin
Password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

5. Deploy the Application
Bashkubectl apply -f argocd-app.yaml
The GitHub Actions pipeline will automatically build, push to ECR, and update the Helm values for ArgoCD to pick up new versions.
GitHub Actions Secrets

Secret                  Description
AWS_ACCESS_KEY_ID       IAM user access key
AWS_SECRET_ACCESS_KEY   IAM user secret key

Features

Full Infrastructure as Code with Terraform
Automated container builds and ECR pushes
GitOps-based continuous deployment with ArgoCD
Monitoring stack (Prometheus + Alertmanager)
Secure Terraform state in S3
Production-grade EKS setup with best practices
