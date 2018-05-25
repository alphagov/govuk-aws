## Project: datagovuk-static-bucket

This creates an s3 bucket

datagovuk-static-bucket: A bucket to hold legacy CKAN static data and assets



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| stackname | Stackname | string | - | yes |

