variable "tenancy_ocid" {
  description = "Your Oracle Cloud tenancy OCID."
  type        = string
}

variable "user_ocid" {
  description = "The OCID of the OCI user for authentication."
  type        = string
}

variable "fingerprint" {
  description = "The fingerprint for the public key used for OCI CLI."
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key for OCI CLI authentication."
  type        = string
}

variable "region" {
  description = "The OCI region to deploy into (e.g., eu-frankfurt-1)."
  type        = string
  default     = "eu-frankfurt-1"
}

variable "availability_domain" {
  description = "Availability domain name (e.g., eu-frankfurt-1-AD-1)."
  type        = string
  default     = "EU-FRANKFURT-1-AD-1"
}

variable "compartment_name" {
  description = "The name of the compartment to be created."
  type        = string
  default     = "vscode-tunnel-tiny-compartment"
}

variable "vcn_cidr_block" {
  description = "CIDR block for the VCN."
  type        = string
  default     = "10.0.0.0/30"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet."
  type        = string
  default     = "10.0.0.0/30"
}

variable "vcn_display_name" {
  description = "Display name of the VCN."
  type        = string
  default     = "vscode-tunnel-tiny-vcn"
}

variable "subnet_display_name" {
  description = "Display name of the subnet."
  type        = string
  default     = "vscode-tunnel-tiny-private-subnet"
}

variable "instance_type" {
  description = "Compute instance type to use."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "instance_name" {
  description = "Display name for the instance."
  type        = string
  default     = "vscode-tunnel-instance"
}

variable "ssh_public_key" {
  description = "Raw SSH public key content."
  type        = string
  sensitive   = true
}

variable "vscode_github_token" {
  description = "GitHub personal access token for VS Code tunnel authentication."
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "Email address to send budget alerts."
  type        = string
  sensitive   = true
}