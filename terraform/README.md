# GOV.UK Terraform resources

## Installation

- [Terraform](https://www.terraform.io/): we use remote state files, which means you can't plan/apply changes if the
version of your local Terraform doesn't match the version that generated the remote state. Currently we assume 0.10.7

## Manage resources

The tfstate bucket needs to exist.

```
cd <project>

# Initialise stack
terraform init --backend-config=./<stackname>.backend

# Check changes:
terraform plan --var-file=../../data/<project>/common.tfvars --var-file=../../data/<project>/<stackname>.tfvars

# Apply changes:
terraform apply --var-file=../../data/<project>/common.tfvars --var-file=../../data/<project>/<stackname>.tfvars
```

## Overriding variables

If a variable from a file needs to be overridden this can be done by specify the desired value after the file e.g.:

```
terraform apply -var-file=./integration.tfvars -var google_project=govuk-test
```

