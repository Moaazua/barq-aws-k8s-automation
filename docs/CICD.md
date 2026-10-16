# CI/CD (GitHub Actions)

```
git push → CI (test + build) ──► main merge → CD: test → build & push (Docker Hub, tag sha-xxxxxxx)
                                                      └► deploy (self-hosted runner on control plane)
                                                           kubectl set image → rollout status → smoke test
                                                           (auto `rollout undo` on failure)
```

## Why a self-hosted runner?
The security groups only allow SSH from one approved IP and the API server (6443) only from the worker SG.
GitHub-hosted runners have changing IPs, so they cannot reach the cluster. A runner installed on the
control-plane node only makes **outbound** connections to GitHub, so no security-group change is needed
and kubectl uses the local `~/.kube/config` that Ansible already creates.

## One-time setup
1. **GitHub secrets** (Repo → Settings → Secrets and variables → Actions):
   - `DOCKERHUB_USERNAME`
   - `DOCKERHUB_TOKEN` (Docker Hub access token with Read & Write; never the password)
2. **Install the runner on the control-plane node** (Repo → Settings → Actions → Runners → New self-hosted runner → Linux x64).
   Run the commands GitHub shows as user `ubuntu`, and when asked for labels enter: `barq`
   ```bash
   ./config.sh --url https://github.com/<owner>/<repo> --token <TOKEN_FROM_GITHUB> --labels barq --unattended
   sudo ./svc.sh install ubuntu && sudo ./svc.sh start
   ```
3. Check on the node: `kubectl get nodes` works as `ubuntu`.
4. If the Docker Hub repo is private, create a pull secret and add `imagePullSecrets` to `k8s/app/app-deployment.yaml`.

## Evidence for the assignment
1. Change `APP_MESSAGE` in `k8s/app-configmap.yaml` or `VERSION` in `app/server.py`, push to a branch → CI runs; merge to `main` → CD runs.
2. `curl http://<worker-ip>:30080/` shows the new version.
3. Screenshots: Actions run (all green), `kubectl rollout history deployment/barq-app`, running image tag.
4. Rollback: Actions → CD → Run workflow → `image_tag` = previous tag (or `kubectl rollout undo deployment/barq-app`).
