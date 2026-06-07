# Troubleshooting Guide

This document summarizes common issues encountered during setup and their solutions.

## Common Issues & Fixes

### Git & Repository

**1. `src refspec main does not match any`**  
No initial commit or branch mismatch.  
```bash
git add .
git commit -m "initial commit"
git branch -M master
git push -u origin master

2. GitHub Authentication Failed
Use a Personal Access Token (PAT) instead of password.
Bash
git remote set-url origin https://<username>:<PAT>@github.com/<username>/<repo>.git

3. Permission Denied (Wrong Account)
Update git config and remote URL to match the correct GitHub account.
Terraform & Infrastructure

4. Helm Provider Fails to Initialize
Ensure Docker Desktop is running before executing Terraform commands.

5. ArgoCD Helm Installation Fails (Kubernetes cluster unreachable)

Add depends_on = [module.eks] in the ArgoCD module
Use proper EKS authentication with data.aws_eks_cluster_auth

6. EKS Cluster Authentication Issues
Refresh kubeconfig:
Bash
aws eks update-kubeconfig --region us-east-1 --name complete-devops-project

7. ArgoCD & Deployment
revision HEAD must be resolved
Set the correct branch in argocd-app.yaml:
YAMLtargetRevision: master

8. YAML Syntax Errors in values.yaml

Always include a space after : (e.g., tag: abc123)
Quote short SHA tags to avoid scientific notation parsing: tag: "a7a26cd"

9. Application Not Accessible

Wait 2–3 minutes for the AWS LoadBalancer to be provisioned
Use the EXTERNAL-IP from kubectl get svc -n default on port 8080

GitHub Actions CI/CD
10. Image Tag Issues in values.yaml
Ensure the sed command preserves proper formatting and quotes the tag.
General Tips

Focus on level=error lines when checking ArgoCD or pod logs.
Ignore level=info messages during debugging.
Run terraform plan -out=tfplan followed by terraform apply tfplan for consistency.
Keep .tfvars, .tfplan, and .terraform/ directories out of version control (already in .gitignore).
