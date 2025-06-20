resource "oci_identity_compartment" "main_compartment" {
  name          = var.compartment_name
  description   = "Compartment for ${var.vcn_display_name}"
  enable_delete = true
}