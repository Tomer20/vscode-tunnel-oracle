# 🚀 Oracle Cloud Infrastructure (OCI) VCN + NAT Terraform Deployment

This repository provisions a **minimal VCN** with a **private subnet**, **NAT gateway**, and all required routing and security using **Oracle Cloud Free Tier** — fully automated via **GitHub Actions**.

---

## ✅ Features

- Creates a **dedicated compartment**
- Builds a **VCN** with a `/30` CIDR block for minimal usage
- Sets up a **private subnet**
- Provisions a **NAT Gateway** for outbound access
- Adds **default security list and routing**
- Supports **OCI default tagging**
- Designed for **CI/CD via GitHub Actions**

---

## 👷‍♂️ Manual Setup (One-Time Only)

### 1. **Create a Free Oracle Cloud Account**
- Sign up: [https://www.oracle.com/cloud/free](https://www.oracle.com/cloud/free)

---

### 2. **Create a Dedicated User for CI/CD (Service Account)**

In the Oracle Cloud Console:

1. Go to **Identity & Security → Users → Create User**
2. Name it something like `terraform-ci`
3. In the new user's details, go to **API Keys → Add API Key**
4. Upload your **public key** (`oci_api_key_public.pem`)
5. Save the **user OCID**, **fingerprint**, and **tenancy OCID**

---

### 3. **Set Up a Default Tag Policy (Optional but Recommended)**

To enforce consistent tagging:

1. Go to **Governance & Administration → Tag Namespaces**
2. Create a namespace (e.g., `project`)
3. Add tag keys (e.g., `environment`, `owner`)
4. Navigate to your **target compartment**
5. Go to **Default Tagging → Create Default Tag**
6. Example:
   - **Namespace**: `project`
   - **Tag key**: `environment`
   - **Value**: `dev`

These tags will be **automatically applied to all resources** created in this compartment — including from Terraform.

---

### 4. **Add Required Secrets to GitHub**

Go to your repository → **Settings → Secrets → Actions** and add:

| Secret Name         | Value (from OCI Console or Key)             |
|---------------------|---------------------------------------------|
| `OCI_TENANCY_OCID`  | Your tenancy OCID                           |
| `OCI_USER_OCID`     | OCID of the `terraform-ci` user             |
| `OCI_FINGERPRINT`   | From key fingerprint                        |
| `OCI_REGION`        | e.g., `eu-frankfurt-1`                      |
| `OCI_PRIVATE_KEY`   | Content of `oci_api_key.pem` (multi-line!) |

---

## ⚙️ How to Deploy (Fully Automated)

After the secrets are added:

1. Push your Terraform code to the **`main`** branch
2. GitHub Actions will:
   - Set up Terraform
   - Authenticate with OCI
   - Initialize and plan the deployment
   - Apply infrastructure changes

---

## 📁 Project Structure

```
.
├── main.tf                # VCN, NAT, Subnet, Routing, Security
├── variables.tf           # Type-safe and documented variables
├── outputs.tf             # Resource IDs output
├── terraform.tfvars       # (Optional) Pre-set values
└── .github/workflows/
 └── deploy.yml            # GitHub Actions workflow
```

---

## 💡 Tips

- Terraform state is **not remote by default** — consider using an [OCI Object Storage backend](https://registry.terraform.io/providers/oracle/oci/latest/docs/guides/state_management).
- Always restrict user permissions via **IAM policies**.
- Use separate compartments per environment (`dev`, `prod`).

---

## 📬 Questions?

Open a GitHub Issue.