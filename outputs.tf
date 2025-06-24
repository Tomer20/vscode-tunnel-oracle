output "vcn_id" {
  description = "OCID of the created VCN"
  value       = oci_core_vcn.main_vcn.id
}

output "vcn_cidr_block" {
  description = "CIDR block of the VCN"
  value       = oci_core_vcn.main_vcn.cidr_block
}

output "nat_gateway_id" {
  description = "OCID of the NAT Gateway"
  value       = oci_core_nat_gateway.nat.id
}

output "private_route_table_id" {
  description = "OCID of the private route table"
  value       = oci_core_route_table.private_rt.id
}

output "private_security_list_id" {
  description = "OCID of the private security list"
  value       = oci_core_security_list.private_sg.id
}

output "private_subnet_id" {
  description = "OCID of the private subnet"
  value       = oci_core_subnet.private_subnet.id
}

output "instance_id" {
  description = "OCID of the compute instance"
  value       = oci_core_instance.tunnel_instance.id
}

output "instance_private_ip" {
  description = "Private IP address of the compute instance"
  value       = oci_core_instance.tunnel_instance.private_ip
}

# output "quota_policy_id" {
#   description = "OCID of the quota policy applied to the compartment"
#   value       = oci_limits_quota.quota_policy.id
# }

# output "budget_id" {
#   description = "OCID of the created budget"
#   value       = oci_budget_budget.free_tier_budget.id
# }

# output "budget_alert_id" {
#   description = "OCID of the budget alert rule"
#   value       = oci_budget_alert_rule.free_tier_alert.id
# }