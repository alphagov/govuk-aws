## Module: projects/infra-dev\_vm

Creates an S3 bucket to store the development VMs used in govuk-puppet  
Vagrantfile

Mifrated from:  
https://github.com/alphagov/govuk-terraform-provisioning/tree/master/old-projects/dev_vm

## Providers

| Name | Version |
|------|---------|
| aws | 2.33.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| bucket\_name | n/a | `string` | `"govuk-dev-boxes"` | no |
| stackname | Stackname | `string` | `""` | no |
| team | n/a | `string` | `"Infrastructure"` | no |
| username | n/a | `string` | `"govuk-dev-box-uploader"` | no |

## Outputs

No output.

