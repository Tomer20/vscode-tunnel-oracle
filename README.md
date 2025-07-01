git config --global user.name "Your Name"
git config --global user.email "your@email.com"
github auth login
code tunnel service install --accept-server-license-terms --name "${INSTANCE_NAME}"

# Enable linger so the tunnel keeps running after logout
loginctl enable-linger $USER
```
# VSCode Tunnel on Oracle Cloud (OCI Free Tier)

> Minimal, automated, and free remote dev environment using VS Code Tunnel on Oracle Cloud Free Tier. Deploys a private VCN, NAT gateway, and compute instance via GitHub Actions and Terraform.

---

## Features

- One-click deploy with GitHub Actions
- Minimal VCN (`/30` CIDR), private subnet, NAT gateway
- Default security lists and routing
- Free tier compute instance for VS Code Tunnel
- Automated OCI compartment and bucket setup
- Budget alert email support

---

## Quick Start

1. **Configure GitHub Secrets/Variables:**
   - `OCI_TENANCY_OCID`, `OCI_USER_OCID`, `OCI_FINGERPRINT`, `OCI_REGION`, `OCI_PRIVATE_KEY`, `MY_PUBLIC_IP_CIDR`, `COMPUTE_SSH_PUBLIC_KEY`, `VSCODE_GITHUB_TOKEN`, `BUDGET_ALERT_EMAIL` (secrets)
   - `OCI_COMPARTMENT_NAME`, `OCI_BUCKET_NAME` (variables)

2. **Run the Deploy Action:**
   - Go to GitHub Actions → Deploy Infrastructure → Run workflow

3. **Post-Deploy (Manual):**
   - Login to OCI, create a Bastion session, copy the SSH command
   - SSH to the bastion server
   - On the server:
     ```sh
     code tunnel service install --accept-server-license-terms --name "${INSTANCE_NAME}"
     loginctl enable-linger $USER
     ```

---

## Useful Commands

```sh
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
gh auth login
```

---

## File Overview

- `01_vcn.tf`, `02_compute.tf`, ...: Terraform modules
- `init.sh`: Initializes OCI resources
- `cloud-init.yaml`: Cloud-init for compute instance
- `.github/workflows/deploy.yaml`: GitHub Actions automation

---

## License

[MIT](./LICENSE)