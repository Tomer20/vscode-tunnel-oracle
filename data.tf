data "oci_identity_compartments" "matching" {
  compartment_id            = var.tenancy_ocid
  name                      = var.compartment_name
  access_level              = "ANY"
  compartment_id_in_subtree = true
  filter {
    name   = "name"
    values = [var.compartment_name]
  }
}

data "oci_identity_compartment" "target" {
  id = data.oci_identity_compartments.matching.compartments[0].id
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "ubuntu" {
  compartment_id           = data.oci_identity_compartment.target.id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}
