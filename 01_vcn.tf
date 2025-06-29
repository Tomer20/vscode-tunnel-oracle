resource "oci_core_vcn" "main_vcn" {
  compartment_id = data.oci_identity_compartment.target.id
  cidr_block     = var.vcn_cidr_block
  display_name   = var.vcn_display_name
  dns_label      = "vscodetunnel"
}

resource "oci_core_nat_gateway" "nat" {
  compartment_id = data.oci_identity_compartment.target.id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "vscodetunnel-nat"
}

resource "oci_core_route_table" "private_rt" {
  compartment_id = data.oci_identity_compartment.target.id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "private-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }
}

resource "oci_core_security_list" "private_sg" {
  compartment_id = data.oci_identity_compartment.target.id
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
  compartment_id              = data.oci_identity_compartment.target.id
  vcn_id                      = oci_core_vcn.main_vcn.id
  cidr_block                  = var.private_subnet_cidr_block
  display_name                = var.subnet_display_name
  route_table_id              = oci_core_route_table.private_rt.id
  security_list_ids           = [oci_core_security_list.private_sg.id]
  prohibit_public_ip_on_vnic  = true
  dns_label                   = "privsub"
  availability_domain         = data.oci_identity_availability_domains.ads.availability_domains[0].name
}