resource "oci_core_instance" "tunnel_instance" {
  availability_domain = var.availability_domain
  compartment_id      = data.oci_identity_compartment.target.id
  display_name        = var.instance_name
  shape               = var.instance_type

  shape_config {
    ocpus         = 4
    memory_in_gbs = 24
  }

  create_vnic_details {
    subnet_id              = oci_core_subnet.private_subnet.id
    assign_public_ip       = false
    display_name           = "${var.instance_name}-vnic"
    skip_source_dest_check = false
  }

  source_details {
    source_type               = "image"
    image_id                  = data.oci_core_image.ubuntu.id
    boot_volume_size_in_gbs   = 50
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(templatefile("${path.module}/cloud-init.yaml", {
      github_token = var.vscode_github_token
      instance_name = var.instance_name
    }))
  }
}