## Project: datagovuk-organogram-bucket

This creates an s3 bucket

datagovuk-organogram-bucket: A bucket to hold data.gov.uk organogram files



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| s3_bucket_read_ips | Additional IPs to allow read access from | list | - | yes |
| stackname | Stackname | string | - | yes |

