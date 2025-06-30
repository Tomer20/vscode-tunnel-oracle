# 🚀 VSCode Tunnel on Oracle Cloud Infrastructure (OCI)

This repository provisions a **minimal VCN** with a **private subnet**, **NAT gateway**, and all required routing and security using **Oracle Cloud Free Tier** — fully automated via **GitHub Actions**.

This project was crested to support **free** remote development using [VSCode web](https://vscode.dev) with the most powerful infra.

---

## ✅ Features

- Init OCI compartment
- Terraform:
   - Builds a **VCN** with a `/30` CIDR block for minimal usage
   - Sets up a **private subnet**
   - Provisions a **NAT Gateway** for outbound access
   - Adds **default security list and routing**
   - Free tier compute instance ready for VS Code Tunnel.

---

## ⚙️ How to Deploy (Fully Automated)

After the secrets and variables are added:

1. [Run the init script](./docs/Init.md)
2. [Deploy the solution via Terraform](./docs/Deploy.md)

---

## Manual Steps After Launch

1. Login to OCI and create bastion session. Copy the SSH command.
2. SSH to the bastion server with the copied command.
3. Run

```
./code tunnel service install --accept-server-license-terms --name "${INSTANCE_NAME}"

# Enable linger so the tunnel keeps running after logout
loginctl enable-linger $USER
```
4. Login from your desired remote machine.

---

## 📬 Questions? Having trouble?

Open a GitHub Issue.

---

## 📝 License

[MIT](./LICENSE).