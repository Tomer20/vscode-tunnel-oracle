variable "tenancy_ocid" {
  description = "Your Oracle Cloud tenancy OCID."
  type        = string
}

variable "user_ocid" {
  description = "The OCID of the OCI user for authentication."
  type        = string
  sensitive   = true
}

variable "fingerprint" {
  description = "The fingerprint for the public key used for OCI CLI."
  type        = string
  sensitive   = true
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
  default     = "10.0.0.0/28"
}

variable "private_subnet_cidr_block" {
  description = "Private subnet CIDR."
  type        = string
  default     = "10.0.0.0/30"
}

variable "public_subnet_cidr_block" {
  description = "Public subnet CIDR."
  type        = string
  default     = "10.0.0.8/29"
}

variable "bastion_enabled" {
  description = "Whether to enable the OCI Bastion service"
  type        = bool
  default     = true
}

variable "my_public_ip_cidr" {
  description = "Your home or office public IPv4 address in CIDR notation (e.g., 203.0.113.42/32)."
  type        = string
  default     = "203.0.113.42/32"
  validation {
    condition     = can(cidrhost(var.my_public_ip_cidr, 0))
    error_message = "The value must be a valid IPv4 CIDR block, e.g., 203.0.113.42/32."
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

variable "budget_alert_email" {
  description = "Email address to send budget alerts."
  type        = string
  sensitive   = true
}

variable "enable_strict_limits" {
  description = "Set to true to enforce strict resource quotas in the compartment. When false, no quota restrictions will be applied."
  type        = bool
  default     = true
}