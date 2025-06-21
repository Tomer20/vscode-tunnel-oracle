resource "oci_limits_quota" "quota_policy" {
  compartment_id = data.oci_identity_compartment.target.id
  name           = "${compartment_name}-restrictions"
  description    = "Restricts usage to specific Terraform-managed resources in ${compartment_name}"
  statements = [
    "allow service compute to use ${var.instance_type} up to 1 in compartment ${compartment_name}",
    "allow service core to use virtual-network-family up to 1 in compartment ${compartment_name}",
    "allow service core to use subnets up to 1 in compartment ${compartment_name}",
    "allow service core to use nat-gateways up to 1 in compartment ${compartment_name}",
    "allow service core to use route-tables up to 1 in compartment ${compartment_name}",
    "allow service core to use security-lists up to 1 in compartment ${compartment_name}",
    "allow service core to use private-ips up to 2 in compartment ${compartment_name}",
    "deny service all to use all-resources in compartment ${compartment_name}"
  ]
}

resource "oci_budget_budget" "free_tier_budget" {
  compartment_id = data.oci_identity_compartment.target.id
  amount         = 0.00
  reset_period   = "MONTHLY"
  target_type    = "COMPARTMENT"
  targets        = [data.oci_identity_compartment.target.id]
  display_name   = "free-tier-budget"
  description    = "Track usage to avoid exceeding free tier"
}

resource "oci_budget_alert_rule" "free_tier_alert" {
  budget_id          = oci_budget_budget.free_tier_budget.id
  display_name       = "free-tier-90-percent"
  type               = "ACTUAL"
  threshold          = 90
  threshold_type     = "PERCENTAGE"
  message            = "Free tier usage exceeded 90%"
  recipients         = [var.budget_alert_email]
  description        = "Alert at 90% of free-tier threshold"
}