locals {
  instance_type = "VM.Standard.A1.Flex" # Always free instance
  ocpus         = 4
  memory_in_gbs = 8
}

resource "oci_core_instance" "tunnel_instance" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = data.oci_identity_compartment.target.id
  display_name        = var.instance_name
  shape                = local.instance_type

  shape_config {
    ocpus         = local.ocpus
    memory_in_gbs = local.memory_in_gbs
  }

  create_vnic_details {
    subnet_id              = oci_core_subnet.private_subnet.id
    assign_public_ip       = false
    display_name           = "${var.instance_name}-vnic"
    skip_source_dest_check = false
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu.images[0].id
    boot_volume_size_in_gbs = 50
  }

  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    network_type                        = "PARAVIRTUALIZED"
    is_pv_encryption_in_transit_enabled = true
    firmware                            = "UEFI_64"
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = true
  }

  dynamic "agent_config" {
    for_each = var.bastion_enabled ? [1] : []

    content {
      is_management_disabled = false
      is_monitoring_disabled = false

      plugins_config {
        name          = "Bastion"
        desired_state = "ENABLED"
      }
    }
  }

  metadata = {
    ssh_authorized_keys = var.compute_ssh_public_key
    user_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
      instance_name = var.instance_name
    }))
  }
}
