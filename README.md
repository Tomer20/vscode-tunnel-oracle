# VSCode Tunnel on Oracle Cloud (OCI Free Tier)

Minimal, automated, and free remote dev environment using VS Code Tunnel on Oracle Cloud Free Tier. Deploys a private VCN, NAT gateway, and compute instance via GitHub Actions and Terraform.

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
     git config --global user.name "Your Name"
     git config --global user.email "your@email.com"
     gh auth login
     code tunnel service install --accept-server-license-terms --name "${INSTANCE_NAME}"
     loginctl enable-linger $USER
     ```

---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.2 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | 7.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 7.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_bastion_bastion.bastion](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/bastion_bastion) | resource |
| [oci_budget_alert_rule.free_tier_alert](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/budget_alert_rule) | resource |
| [oci_budget_budget.free_tier_budget](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/budget_budget) | resource |
| [oci_core_instance.tunnel_instance](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/core_instance) | resource |
| [oci_core_internet_gateway.igw](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/core_internet_gateway) | resource |
| [oci_core_nat_gateway.nat](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/core_nat_gateway) | resource |
| [oci_core_route_table.private_rt](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/core_route_table) | resource |
| [oci_core_route_table.public_rt](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/core_route_table) | resource |
| [oci_core_security_list.private_sg](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/core_security_list) | resource |
| [oci_core_security_list.public_sg](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/core_security_list) | resource |
| [oci_core_subnet.private_subnet](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/core_subnet) | resource |
| [oci_core_subnet.public_subnet](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/core_subnet) | resource |
| [oci_core_vcn.main_vcn](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/core_vcn) | resource |
| [oci_limits_quota.quota_policy](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/resources/limits_quota) | resource |
| [oci_core_images.ubuntu](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/data-sources/core_images) | data source |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/data-sources/identity_availability_domains) | data source |
| [oci_identity_compartment.target](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/data-sources/identity_compartment) | data source |
| [oci_identity_compartments.matching](https://registry.terraform.io/providers/oracle/oci/7.7.0/docs/data-sources/identity_compartments) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_enabled"></a> [bastion\_enabled](#input\_bastion\_enabled) | Whether to enable the OCI Bastion service | `bool` | `true` | no |
| <a name="input_budget_alert_email"></a> [budget\_alert\_email](#input\_budget\_alert\_email) | Email address to send budget alerts. | `string` | n/a | yes |
| <a name="input_compartment_name"></a> [compartment\_name](#input\_compartment\_name) | The name of the compartment to be created. | `string` | n/a | yes |
| <a name="input_compute_ssh_public_key"></a> [compute\_ssh\_public\_key](#input\_compute\_ssh\_public\_key) | Raw SSH public key content. | `string` | n/a | yes |
| <a name="input_enable_strict_limits"></a> [enable\_strict\_limits](#input\_enable\_strict\_limits) | Set to true to enforce strict resource quotas in the compartment. When false, no quota restrictions will be applied. | `bool` | `true` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | The fingerprint for the public key used for OCI CLI. | `string` | n/a | yes |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Display name for the instance. | `string` | `"vscode-tunnel-instance"` | no |
| <a name="input_my_public_ip_cidr"></a> [my\_public\_ip\_cidr](#input\_my\_public\_ip\_cidr) | Your home or office public IPv4 address in CIDR notation (e.g., 203.0.113.42/32). | `string` | `"203.0.113.42/32"` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | Path to the private key for OCI CLI authentication. | `string` | n/a | yes |
| <a name="input_private_subnet_cidr_block"></a> [private\_subnet\_cidr\_block](#input\_private\_subnet\_cidr\_block) | Private subnet CIDR. | `string` | `"10.0.0.0/30"` | no |
| <a name="input_public_subnet_cidr_block"></a> [public\_subnet\_cidr\_block](#input\_public\_subnet\_cidr\_block) | Public subnet CIDR. | `string` | `"10.0.0.8/29"` | no |
| <a name="input_region"></a> [region](#input\_region) | The OCI region to deploy into (e.g., eu-frankfurt-1). | `string` | n/a | yes |
| <a name="input_subnet_display_name"></a> [subnet\_display\_name](#input\_subnet\_display\_name) | Display name of the subnet. | `string` | `"vscode-tunnel-private-subnet"` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | Your Oracle Cloud tenancy OCID. | `string` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | The OCID of the OCI user for authentication. | `string` | n/a | yes |
| <a name="input_vcn_cidr_block"></a> [vcn\_cidr\_block](#input\_vcn\_cidr\_block) | Minimal VCN CIDR block. | `string` | `"10.0.0.0/28"` | no |
| <a name="input_vcn_display_name"></a> [vcn\_display\_name](#input\_vcn\_display\_name) | Display name of the VCN. | `string` | `"vscode-tunnel-vcn"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_id"></a> [bastion\_id](#output\_bastion\_id) | OCID of the Bastion service |
| <a name="output_bastion_name"></a> [bastion\_name](#output\_bastion\_name) | Name of the Bastion |
| <a name="output_budget_alert_id"></a> [budget\_alert\_id](#output\_budget\_alert\_id) | OCID of the budget alert rule |
| <a name="output_budget_id"></a> [budget\_id](#output\_budget\_id) | OCID of the created budget |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | OCID of the compute instance |
| <a name="output_instance_private_ip"></a> [instance\_private\_ip](#output\_instance\_private\_ip) | Private IP address of the compute instance |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | OCID of the Internet Gateway |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | OCID of the NAT Gateway |
| <a name="output_private_route_table_id"></a> [private\_route\_table\_id](#output\_private\_route\_table\_id) | OCID of the private route table |
| <a name="output_private_security_list_id"></a> [private\_security\_list\_id](#output\_private\_security\_list\_id) | OCID of the private security list |
| <a name="output_private_subnet_id"></a> [private\_subnet\_id](#output\_private\_subnet\_id) | OCID of the private subnet |
| <a name="output_public_route_table_id"></a> [public\_route\_table\_id](#output\_public\_route\_table\_id) | OCID of the public route table |
| <a name="output_public_security_list_id"></a> [public\_security\_list\_id](#output\_public\_security\_list\_id) | OCID of the public security list |
| <a name="output_public_subnet_id"></a> [public\_subnet\_id](#output\_public\_subnet\_id) | OCID of the public subnet |
| <a name="output_quota_policy_id"></a> [quota\_policy\_id](#output\_quota\_policy\_id) | OCID of the quota policy applied to the compartment |
| <a name="output_vcn_cidr_block"></a> [vcn\_cidr\_block](#output\_vcn\_cidr\_block) | CIDR block of the VCN |
| <a name="output_vcn_id"></a> [vcn\_id](#output\_vcn\_id) | OCID of the created VCN |
<!-- END_TF_DOCS -->

---

## License

[MIT](./LICENSE)
