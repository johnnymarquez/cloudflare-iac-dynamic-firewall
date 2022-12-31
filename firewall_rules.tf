// Default firewall rules in range 10 - 1000
resource "cloudflare_filter" "filter" {
  count = length(var.fw_rules)

  expression = <<EOT
${var.fw_rules[count.index].expression} or (http.host eq "${random_string.default[count.index].result}")
  EOT
  paused     = var.fw_rules[count.index].paused
  zone_id    = cloudflare_zone.zone.id
}

resource "cloudflare_firewall_rule" "firewall_rule" {
  count = length(var.fw_rules)

  action      = var.fw_rules[count.index].action
  filter_id   = cloudflare_filter.filter[count.index].id
  zone_id     = cloudflare_zone.zone.id
  description = var.fw_rules[count.index].description
  paused      = var.fw_rules[count.index].paused
  priority    = 10 + (count.index * 10)
  products    = var.fw_rules[count.index].products
}

// Whitelist Developers
resource "cloudflare_filter" "devs_allow_web_access" {
  count = var.fw_rules_extra.enabled ? 1 : 0

  expression = <<EOT
  EOT
  paused     = var.fw_rules_extra.paused
  zone_id    = cloudflare_zone.zone.id
}

resource "cloudflare_firewall_rule" "devs_allow_web_access" {
  count = var.fw_rules_extra.enabled ? 1 : 0

  action      = var.fw_rules_extra.action
  filter_id   = try(cloudflare_filter.devs_allow_web_access[0].id, null)
  zone_id     = cloudflare_zone.zone.id
  description = var.fw_rules_extra.description
  paused      = var.fw_rules_extra.paused
  priority    = 10 + (length(cloudflare_firewall_rule.firewall_rule) * 10)
  products    = var.fw_rules_extra.products
}

// Random string values to dynamically change filter expressions
resource "random_string" "default" {
  count   = length(var.fw_rules)
  length  = 16
  special = false
  upper   = false
}
