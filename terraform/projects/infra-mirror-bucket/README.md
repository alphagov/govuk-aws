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
| cloudfront_assets_certificate_domain | The domain of the Assets CloudFront certificate to look up. | string | `` | no |
| cloudfront_assets_distribution_aliases | Extra CNAMEs (alternate domain names), if any, for the Assets CloudFront distribution. | list | `<list>` | no |
| cloudfront_create | Create Cloudfront resources. | string | `false` | no |
| cloudfront_enable | Enable Cloudfront distributions. | string | `false` | no |
| cloudfront_lambda_version | The version of the lambda to use with the cloudfront instance | string | `` | no |
| cloudfront_www_certificate_domain | The domain of the WWW CloudFront certificate to look up. | string | `` | no |
| cloudfront_www_distribution_aliases | Extra CNAMEs (alternate domain names), if any, for the WWW CloudFront distribution. | list | `<list>` | no |
| office_ips | An array of CIDR blocks that will be allowed offsite access. | list | - | yes |
| remote_state_app_mirrorer_key_stack | stackname path to app_mirrorer remote state | string | `` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| stackname | Stackname | string | - | yes |

