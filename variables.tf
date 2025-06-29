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
}

variable "compartment_name" {
  description = "The name of the compartment to be created."
  type        = string
}

variable "vcn_cidr_block" {
  description = "Minimal VCN CIDR block."
  type        = string
  default     = "10.0.0.0/29"
}

variable "private_subnet_cidr_block" {
  description = "Private subnet CIDR."
  type        = string
  default     = "10.0.0.0/30"
}

variable "public_subnet_cidr_block" {
  description = "Public subnet CIDR."
  type        = string
  default     = "10.0.0.4/30"
}

variable "bastion_enabled" {
  description = "Whether to enable the OCI Bastion service"
  type        = bool
  default     = true
}

variable "my_public_ip" {
  description = "Your home or office public IPv4 address (used to restrict SSH/Bastion access)."
  type        = string
  default     = "0.0.0.0"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.my_public_ip))
    error_message = "The value must be a valid IPv4 address."
  }
}

variable "vcn_display_name" {
  description = "Display name of the VCN."
  type        = string
  default     = "vscode-tunnel-vcn"
}

variable "subnet_display_name" {
  description = "Display name of the subnet."
  type        = string
  default     = "vscode-tunnel-private-subnet"
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

variable "compute_ssh_public_key" {
  description = "Raw SSH public key content."
  type        = string
  sensitive   = true
}

variable "vscode_github_token" {
  description = "GitHub personal access token for VS Code tunnel authentication."
  type        = string
  sensitive   = true
}

variable "budget_alert_email" {
  description = "Email address to send budget alerts."
  type        = string
  sensitive   = true
}