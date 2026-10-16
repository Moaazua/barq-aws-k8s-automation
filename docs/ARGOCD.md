# GitOps with ArgoCD

GitHub Actions (CI) -> Docker Hub -> commit new tag to Git -> ArgoCD (in cluster) syncs -> rolling update.

## 1. Install ArgoCD (on the control plane)
```bash
kubectl create namespace argocd
kubectl apply -n argocd --server-side -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd -w          # wait until all Running
```

## 2. Open the UI
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"NodePort","ports":[{"port":443,"nodePort":30443}]}}'
# https://<node-ip>:30443   (on EC2 also open 30443 for your IP only)
# or: kubectl port-forward svc/argocd-server -n argocd 8080:443
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```
User: `admin`.

## 3. Prepare the cluster
- Create the real secret manually (never in Git): `kubectl apply -f app-secret.yaml` (copy of `k8s/app-secret.example.yaml` with real values).
- If the GitHub repo is private: Settings -> Repositories -> Connect Repo (HTTPS + Personal Access Token, read-only).

## 4. Create the Application
```bash
kubectl apply -f argocd/barq-app.yaml
```
`automated` + `selfHeal` = ArgoCD deploys every Git change and reverts manual `kubectl` edits.

## 5. Demo / evidence
1. Change the app (e.g. `APP_MESSAGE` in `k8s/app-configmap.yaml` or `VERSION` in `app/server.py`) and push to `main`.
2. Show: Actions run green -> new commit `ci: deploy barq-app sha-xxxxxxx` -> ArgoCD Synced/Healthy -> `curl` shows the change.
3. Rollback: `git revert <commit>` and push (the GitOps way), or ArgoCD UI -> History and Rollback
   (disable auto-sync first, otherwise it syncs back to Git).
4. Self-heal: `kubectl scale deploy barq-app --replicas=5` -> ArgoCD sets it back to 2.
