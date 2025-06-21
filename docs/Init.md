# 🚀 OCI Terraform Backend Bootstrap

An automated setup of an Oracle Cloud Infrastructure (OCI) backend for storing Terraform state in a versioned and encrypted Object Storage bucket.

---

## 🧱 What It Does

The GitHub Actions workflow:

- Creates a compartment (`${{ vars.OCI_COMPARTMENT_NAME }}`)
- Creates a versioned, encrypted Object Storage bucket (`${{ vars.OCI_BUCKET_NAME }}`)
- Generates a `backend.tf` with correct values
- Commits the file to the repo

---

## ⚙️ Prerequisites

### 1. OCI Setup

- [Create an OCI account](https://www.oracle.com/cloud/free)
- Generate an API key for your user

---

### 2. GitHub Secrets

Go to **Repo → Settings → Secrets → Actions**, and add:

| Name                | Description                            |
|---------------------|----------------------------------------|
| `OCI_TENANCY_OCID`  | Your tenancy OCID                      |
| `OCI_USER_OCID`     | IAM user OCID                          |
| `OCI_FINGERPRINT`   | API key fingerprint                    |
| `OCI_PRIVATE_KEY`   | RSA private key (multiline)            |
| `OCI_REGION`        | OCI region (e.g., `eu-frankfurt-1`)    |

---

### 3. GitHub Variables

Go to **Repo → Settings → Variables → Actions**, and add:

| Name                   | Value                        |
|------------------------|------------------------------|
| `OCI_COMPARTMENT_NAME` | `vscode-tunnel-compartment`  |
| `OCI_BUCKET_NAME`      | `vscode-tunnel-bucket`       |

---

## ▶️ Running the Workflow

1. Go to **Actions**
2. Click **"Init OCI"**
3. Click **"Run workflow"**

This will create the resources (if missing), generate `backend.tf`, and push it to your branch.

---

## 📂 `backend.tf` Example

```hcl
terraform {
  backend "oci" {
    bucket         = "vscode-tunnel-bucket"
    namespace      = "<fetched automatically>"
    compartment_id = "<fetched automatically>"
    region         = "eu-frankfurt-1"
    key            = "terraform.tfstate"
  }
}
```

---

## 🔐 Notes

- The bucket is private, versioned, and encrypted by default
- The workflow uses `GITHUB_TOKEN` to commit — ensure write permissions are enabled in repo settings:
  `Settings → Actions → Workflow permissions → Read and write`
