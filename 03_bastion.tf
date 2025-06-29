resource "oci_core_internet_gateway" "igw" {
  count = var.bastion_enabled ? 1 : 0
  compartment_id = data.oci_identity_compartment.target.id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "vscodetunnel-igw"
  enabled        = true
}

resource "oci_core_route_table" "public_rt" {
  count = var.bastion_enabled ? 1 : 0
  compartment_id = data.oci_identity_compartment.target.id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw[0].id
  }
}

resource "oci_core_security_list" "public_sg" {
  count = var.bastion_enabled ? 1 : 0
  compartment_id = data.oci_identity_compartment.target.id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "public-sec-list"

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"  # TCP
    source   = var.my_public_ip
    tcp_options {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_subnet" "public_subnet" {
  count = var.bastion_enabled ? 1 : 0
  compartment_id              = data.oci_identity_compartment.target.id
  vcn_id                      = oci_core_vcn.main_vcn.id
  cidr_block                  = var.public_subnet_cidr_block
  display_name                = "bastion-public-subnet"
  route_table_id              = oci_core_route_table.public_rt[0].id
  security_list_ids           = [oci_core_security_list.public_sg[0].id]
  prohibit_public_ip_on_vnic  = false
  dns_label                   = "pubsub"
  availability_domain         = data.oci_identity_availability_domains.ads.availability_domains[0].name
}

resource "oci_bastion_bastion" "bastion" {
  count = var.bastion_enabled ? 1 : 0
  compartment_id   = data.oci_identity_compartment.target.id
  target_subnet_id = oci_core_subnet.public_subnet[0].id

  name = "bastion-service"
  bastion_type = "STANDARD"

  client_cidr_block_allow_list = [var.my_public_ip]
  max_session_ttl_in_seconds = 10800 # 3 hours
}