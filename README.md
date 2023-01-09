# Cloudflare Infrastructure as Code Dynamical Allocation of Firewall Rules

The following repository contains sample infrastructure as code for managing Cloudflare resources. Relevant feature
include the dynamic provisioning of new rules.

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

The process to include a new rule is to add it into the sets of strings in fw_rules_default (variables.tf),
fw_rules_brand (env/brand.tfvars),
fw_rules_asn_bot(env/brand.tfvars) and fulfilling the required fields.
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
For the description field, ideally it should be composed of "actions:brand/description"

