## Project: datagovuk-static-bucket

This creates an s3 bucket

datagovuk-static-bucket: A bucket to hold legacy CKAN static data and assets

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| fastly | n/a |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| s3\_bucket\_read\_ips | Additional IPs to allow read access from | `list` | n/a | yes |
| stackname | Stackname | `string` | n/a | yes |

## Outputs

No output.

