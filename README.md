# Cloudflare Infrastructure as Code Dynamical Allocation of Firewall Rules

The following repository contains sample infrastructure as code for managing Cloudflare resources. Relevant features
include the dynamic provisioning of new rules and rulesets using Terraform's dynamic nested
blocks. [Reference](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks).

## Export Api Key & Email as environment variables or secrets to maintain security

        export TF_VAR_cf_apikey=''
        export TF_VAR_cf_email=''
        export TF_VAR_account_id=''

## Fulfill zone settings

        tfvars/environment.tfvars with zone information

## Local workflow

        terraform init
        terraform workspace new sandbox
        terraform plan --var-file=tfvars/sandbox.tfvars

## Firewall Rules

The process to include a new rule is to add it into the sets of strings in the ```tfvars/env``` file, since this would
allow
to dynamically assign different rules to specific workspaces. A different approach would be to assign the rules with the
same format into the ```fw_rules``` resource inside ```variables.tf```
Example:

```
{
   action = "allow"
   description = "allow:amv/acceptlist-aws"
   expression = "(ip.src in $amv_aws)"
   paused = false
   products = []
},
```

For possible values on action, expression, and products, please refer to
[Cloudflare Documentation](https://developers.cloudflare.com/firewall/).
For the description field, a personal preference is to include enough detail in the
format ```actions:brand/description```

## Ruleset

Dynamic Ruleset resource has the capability to automatically create new resources by just listing them as a list of
objects into the ```tfvars/env``` file. With the given structure, the resource allows un unlimited number of rulesets
with unlimited number of nested headers inside whichever ruleset created.
The following is an example structure that can increase according to the needs of the project. However, as a good
practice and to maintain a clear organization, the nested Rulesets should belong to the same purpose/project/subject.
When your project requires a new kind of Releset, the generation of a new ```resource``` or ```terraform``` file would
be better suited.

```
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
```