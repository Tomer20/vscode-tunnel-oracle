output "vcn_id" {
  value = oci_core_vcn.main_vcn.id
}

output "subnet_id" {
  value = oci_core_subnet.private_subnet.id
}