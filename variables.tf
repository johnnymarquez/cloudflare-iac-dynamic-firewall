variable "env" {
  type    = string
  default = ""
}

variable "cf_email" {
  description = "Cloudflare Email"
  type        = string
  sensitive   = true
}

variable "cf_apikey" {
  description = "Cloudflare Global API Key"
  type        = string
  sensitive   = true
}

  variable "account_id" {
  description = "Account ID"
  type        = string
}

variable "zone" {
  description = "Map of project names to configuration."
  type        = object({
    paused = bool,
    plan   = string,
    type   = string,
    zone   = string,
  })
}

variable "fw_rules" {
  description = "Default Firewall Rules"
  type        = list(object({
    action      = string,
    description = string,
    expression  = string,
    paused      = bool,
    products    = set(string),
  }))
  default = [
    {
      action      = "allow"
      description = "Allow rule"
      expression  = ""
      paused      = false
      products    = []
    },
    # Add dynamically more rules as sets of strings
    #    {
    #      action      = "allow"
    #      description = "allow:amv/acceptlist-aws"
    #      expression  = "(ip.src in $amv_aws)"
    #      paused      = false
    #      products    = []
    #    }
  ]
}

variable "fw_rules_extra" {
  description = "Extra rule managed outside of scope"
  type        = object({
    enabled     = bool,
    action      = string,
    description = string,
    paused      = bool,
    products    = set(string),
  })
  default = {
    enabled     = false
    action      = "allow"
    description = ""
    paused      = true
    products    = []
  }
}