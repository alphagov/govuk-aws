# GOV.UK Terraform resources

## Installation

- [Terraform](https://www.terraform.io/): we use remote state files, which means you can't plan/apply changes if the
version of your local Terraform doesn't match the version that generated the remote state. Currently we assume 0.10.8

- [Terraform docs](https://github.com/segmentio/terraform-docs/releases/tag/v0.3.0): In order to generate terraform docs and successfully pass the CI process you need to have this binary installed on your local system.
Currently we assume 0.3.0

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

