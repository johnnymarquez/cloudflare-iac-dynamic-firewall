# Cloudflare Infrastructure as Code

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

