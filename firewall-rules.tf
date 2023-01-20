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

// Random string values to dynamically change filter expressions
resource "random_string" "default" {
  count   = length(var.fw_rules)
  length  = 16
  special = false
  upper   = false
}
