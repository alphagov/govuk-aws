# GOV.UK Terraform resources

## Installation

- [Terraform](https://www.terraform.io/): we use remote state files, which means you can't plan/apply changes if the version of your local Terraform doesn't match the version that generated the remote state. The version is specified in [.terraform-version](../.terraform-version).

- We use a tool called [terraform-docs](https://github.com/segmentio/terraform-docs) to create documentation for our Terraform modules and projects as README files. This runs on CI with the latest version from Homebrew. You can install this locally with `brew install terraform-docs` and update the docs for the files you've changed using `./tools/update-docs.sh`.

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

