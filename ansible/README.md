# Ansible: Kubernetes cluster (kubeadm on EC2 Ubuntu 24.04)

Builds a 2-node cluster (1 control plane + 1 worker, containerd, Flannel) on the
EC2 instances created by Terraform. Safe to re-run (idempotent).

## Prerequisites (on the machine that runs Ansible)
- Ansible >= 2.15, `terraform`, `jq`
- The EC2 key (`.pem`) with permissions `chmod 400`
- This machine's public IP must be allowed in Terraform `allowed_ssh_cidr`

## Run
```bash
cd ansible
ansible-galaxy collection install -r requirements.yml

export BARQ_SSH_KEY=~/.ssh/barq-k8s-key.pem     # path to your key
./scripts/generate_inventory.sh                  # builds inventory/hosts.ini from `terraform output`

ansible all -m ping                              # both hosts must answer "pong"
ansible-playbook k8s-cluster-playbook.yml                        # first run: builds the cluster
ansible-playbook k8s-cluster-playbook.yml                        # re-run: should report changed=0 (or near 0)
```

## Required Terraform outputs (terraform/root/outputs.tf)
`control_plane_public_ip`, `control_plane_private_ip`, `worker_public_ip`, `worker_private_ip`

```hcl
output "control_plane_public_ip"  { value = module.ec2.control_plane_public_ip }
output "control_plane_private_ip" { value = module.ec2.control_plane_private_ip }
output "worker_public_ip"         { value = module.ec2.worker_public_ip }
output "worker_private_ip"        { value = module.ec2.worker_private_ip }
```

## Notes
- `kubeadm init` uses the control plane **private** IP; the public IP is added to the API cert SANs.
- If you stop/start the instances the public IPs change: re-run `generate_inventory.sh`.
- Idempotency: `kubeadm init` is skipped if `/etc/kubernetes/admin.conf` exists, `kubeadm join` if `/etc/kubernetes/kubelet.conf` exists.
- Reset a broken node: `sudo kubeadm reset -f && sudo rm -rf /etc/cni/net.d`
