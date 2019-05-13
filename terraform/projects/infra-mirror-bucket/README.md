## Project: infra-mirror-bucket

This project creates two s3 buckets: a primary s3 bucket to store the govuk
mirror files and a replica s3 bucket which tracks the primary s3 bucket.

The primary bucket should be in London and the backup in Ireland.



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app_mirrorer_stackname | Stackname of the app mirrorer | string | - | yes |
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region where primary s3 bucket is located | string | `eu-west-2` | no |
| aws_replica_region | AWS region where replica s3 bucket is located | string | `eu-west-1` | no |
| office_ips | An array of CIDR blocks that will be allowed offsite access. | list | - | yes |
| remote_state_app_mirrorer_key_stack | stackname path to app_mirrorer remote state | string | `` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| stackname | Stackname | string | - | yes |

