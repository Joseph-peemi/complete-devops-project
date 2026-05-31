# Complete DevOps Project

A complete DevOps pipeline using Docker, Terraform, Minikube, Helm, ArgoCD and GitHub Actions.

---

## Project Stack

- **App**: Python (Flask) containerized with Docker
- **CI/CD**: GitHub Actions
- **Infrastructure**: Terraform (Minikube + Helm providers)
- **Cluster**: Minikube (Docker driver)
- **GitOps**: ArgoCD
- **Packaging**: Helm Chart

---

## How to Run

### Prerequisites
- Docker Desktop running
- Minikube installed
- Terraform installed
- ArgoCD CLI installed
- kubectl installed

### 1. Start Minikube
```bash
provisioned with terraform
```

### 2. Provision Infrastructure with Terraform
```bash
cd terraform-configs
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### 3. Access ArgoCD
```bash
kubectl port-forward svc/argocd-server -n argocd 8081:80
```
Open `http://localhost:8081` in your browser.

Get the initial admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### 4. Deploy the Application
```bash
kubectl apply -f argocd-app.yaml
```

---

## Issues Solved

### 1. Git Push — `src refspec main does not match any`
No commits existed or the branch was named `master` not `main`.
```bash
git add .
git commit -m "initial commit"
git branch -M main
git push -u origin main
```

### 2. GitHub Authentication Failed
GitHub no longer accepts passwords for HTTPS. Fixed by using a Personal Access Token (PAT):
```bash
git remote set-url origin https://<username>:<PAT>@github.com/<username>/<repo>.git
```

### 3. Wrong GitHub Account (403 Permission Denied)
Was authenticated as `JosephAbuchi` but pushing to `Joseph-Peemi`'s repo. Fixed by updating git config and remote URL:
```bash
git config --global user.name "Joseph-Peemi"
git remote set-url origin https://Joseph-Peemi@github.com/Joseph-peemi/complete-devops-project.git
```

### 4. Terraform `terraform plan` Warning — No `-out` Option
Terraform warned that without saving the plan, it can't guarantee exact actions on apply. Fixed by always saving the plan:
```bash
terraform plan -out=tfplan
terraform apply tfplan
```

### 5. Helm Provider Timeout — `Failed to load plugin schemas`
The Helm provider couldn't start because Minikube/Docker was not running. Fix: always start Docker Desktop and Minikube before running any Terraform commands.

### 6. ArgoCD Helm Installation Failed — `Kubernetes cluster unreachable`
ArgoCD Helm release was trying to install before Minikube was ready. Fixed by:
- Adding `depends_on = [minikube_cluster.minikube_docker]` to `argocd.tf`
- Fixing the Helm provider config in `provider.tf` to use Minikube cluster credentials instead of `~/.kube/config`
- Uncommenting the Helm provider and ArgoCD resource blocks

### 7. Minikube Failed — `x509: cannot parse IP address of length 0`
Stale/corrupted Minikube certificates from a previous failed run. Fixed by deleting the old cluster and clearing certs:
```bash
minikube delete --profile complete-devops-project
rm -rf ~/.minikube/certs
```

### 8. Stuck Terraform/Helm Processes (`UE` state)
Multiple hung `terraform-provider-helm` processes in Uninterruptible state. Fixed by killing them:
```bash
kill -9 <PID>
```
If still stuck (UE state), a full Mac restart is required.

### 9. ArgoCD Session Token Invalid
Running `argocd repo add` failed with `token signature is invalid`. Fixed by logging in again:
```bash
argocd login localhost:8081 --insecure --username admin --password <password>
```

### 10. `argocd-app.yaml` — `apiVersion not set`
`apiversion` was lowercase. Fixed by correcting the casing and also moving `destination` out of `source` to the correct `spec` level:
```yaml
apiVersion: argoproj.io/v1alpha1  # capital V
spec:
  source:
    ...
  destination:  # must be at spec level, not inside source
    server: "https://kubernetes.default.svc"
    namespace: default
```

### 11. ArgoCD — `revision HEAD must be resolved`
ArgoCD couldn't resolve `HEAD` because the branch is named `master`. Spotted by finding the only `level=error` line in the logs:
```
grpc.error="rpc error: code = Unknown desc = revision HEAD must be resolved"
```
Fixed by updating `argocd-app.yaml`:
```yaml
targetRevision: master
```

### 12. `values.yaml` YAML Syntax Error — `could not find expected ':'`
Missing space after `tag:` in `values.yaml`:
```yaml
# wrong
tag:a7a26cd

# correct
tag: a7a26cd
```

### 13. CI Pipeline Kept Reintroducing the `values.yaml` Bug
The GitHub Actions `sed` command was stripping the space on every pipeline run:
```bash
# wrong
sed -i "s/tag:.*/tag:${{ env.SHORT_SHA }}/"

# correct
sed -i "s/tag:.*/tag: ${{ env.SHORT_SHA }}/"
```

### 14. Git Push Rejected — `non-fast-forward`
Local branch was behind remote. Fixed by rebasing before pushing:
```bash
git pull origin master --rebase
git push origin master
```

### 15. Detached HEAD State
Was not on any branch after rebase operations. Fixed by checking out master:
```bash
git checkout master
git pull origin master --rebase
git push origin master
```

---

## How to Read Logs for Errors

When debugging with `kubectl logs`, ignore all `level=info` lines and focus on:
- `level=error` — something went wrong
- `grpc.code=Unknown` — confirms a failure
- `desc = ...` — the human-readable error message

Example:
```
level=error grpc.code=Unknown grpc.error="rpc error: code = Unknown desc = revision HEAD must be resolved"
```
