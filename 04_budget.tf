# See available quotas by service:
# https://docs.oracle.com/en-us/iaas/Content/Quotas/Concepts/resourcequotas_topic-Available_Quotas_by_Service.htm
resource "oci_limits_quota" "quota_policy" {
  count          = var.enable_strict_limits ? 1 : 0
  compartment_id = var.tenancy_ocid
  name           = "${var.compartment_name}-restrictions"
  description    = "Restricts usage to specific Terraform-managed resources in ${var.compartment_name}"
  statements = [
    "zero compute-core quota in compartment ${var.compartment_name}",
    "zero compute-memory quota in compartment ${var.compartment_name}",
    "set compute-core quota standard-a1-core-count to 4 in compartment ${var.compartment_name}",
    "set compute-memory quota standard-a1-memory-count to 24 in compartment ${var.compartment_name}",
    "set vcn quota vcn-count to 1 in compartment ${var.compartment_name}"
  ]
}

resource "oci_budget_budget" "free_tier_budget"    {
  compartment_id = var.tenancy_ocid
  amount         = 1
  reset_period   = "MONTHLY"
  target_type    = "COMPARTMENT"
  targets        = [data.oci_identity_compartment.target.id]
  display_name   = "free-tier-budget"
  description    = "Track usage to avoid exceeding free tier"
}

resource "oci_budget_alert_rule" "free_tier_alert" {
  budget_id      = oci_budget_budget.free_tier_budget.id
  display_name   = "free-tier-1-euro-cent"
  type           = "ACTUAL"
  threshold      = 0.01
  threshold_type = "ABSOLUTE"
  message        = "Free-tier usage has reached €0.01"
  recipients     = var.budget_alert_email
  description    = "Sends an alert when actual spend reaches €0.01 to monitor free-tier usage"
}
