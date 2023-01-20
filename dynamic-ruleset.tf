resource "cloudflare_ruleset" "dynamic_ruleset" {
  kind    = "zone"
  name    = "default"
  phase   = "http_response_headers_transform" # Example
  zone_id = cloudflare_zone.zone.id

  dynamic "rules" {
    for_each = var.dynamic_ruleset[*]
    content {
      action      = rules.value.action
      description = rules.value.description
      enabled     = rules.value.enabled
      expression  = rules.value.expression
      action_parameters {
        dynamic "headers" {
          for_each = rules.value.headers
          content {
            name      = headers.value.name
            operation = headers.value.operation
            value     = headers.value.value
          }
        }
      }
    }
  }
}

