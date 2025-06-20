data "oci_core_image" "ubuntu" {
  compartment_id           = oci_identity_compartment.main_compartment.id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}