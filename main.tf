provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

resource "oci_identity_compartment" "main_compartment" {
  name          = var.compartment_name
  description   = "Compartment for ${var.vcn_display_name}"
  enable_delete = true
}

resource "oci_core_vcn" "main_vcn" {
  compartment_id = oci_identity_compartment.main_compartment.id
  cidr_block     = var.vcn_cidr_block
  display_name   = var.vcn_display_name
  dns_label      = "vscodetunnel"
}

resource "oci_core_nat_gateway" "nat" {
  compartment_id = oci_identity_compartment.main_compartment.id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "vscodetunnel-nat"
}

resource "oci_core_route_table" "private_rt" {
  compartment_id = oci_identity_compartment.main_compartment.id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "private-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }
}

resource "oci_core_security_list" "private_sg" {
  compartment_id = oci_identity_compartment.main_compartment.id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "private-sec-list"

  egress_security_rules {
    protocol = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"  # TCP
    source   = var.vcn_cidr_block
    tcp_options {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_subnet" "private_subnet" {
  compartment_id              = oci_identity_compartment.main_compartment.id
  vcn_id                      = oci_core_vcn.main_vcn.id
  cidr_block                  = var.subnet_cidr_block
  display_name                = var.subnet_display_name
  route_table_id              = oci_core_route_table.private_rt.id
  security_list_ids           = [oci_core_security_list.private_sg.id]
  prohibit_public_ip_on_vnic  = true
  dns_label                   = "privsub"
  availability_domain         = var.availability_domain
}