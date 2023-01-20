env = "sandbox"

zone = {
  paused = false
  plan   = "enterprise"
  type   = "full"
  zone   = ""
}

fw_rules = [
  {
    action      = "allow"
    description = "rule1"
    expression  = <<EOT
      EOT
    paused      = false
    products    = []
  },
  {
    action      = "allow"
    description = "rule2"
    expression  = <<EOT
    EOT
    paused      = false
    products    = []
  },
]

dynamic_ruleset = [
  {
    action      = "rewrite",
    description = "ClientHints",
    enabled     = true
    expression  = "(http.request.method eq \"GET\")"
    headers     = [
      {
        name      = "accept-ch"
        operation = "set"
        value     = "sec-ch-ua-model,sec-ch-ua-platform-version"
      },
      {
        name      = "permissions-policy"
        operation = "set"
        value     = "ch-ua-model=*,ch-ua-platform-version=*"
      },
    ]
  },
  {
    action      = "rewrite",
    description = "X-Frame-Options header prevents click-jacking attacks",
    enabled     = true
    expression  = "(not http.request.uri.path matches \"^/api/.*\")"
    headers     = [
      {
        name      = "X-Frame-Options"
        operation = "set"
        value     = "DENY"
      },
    ]
  },
]
