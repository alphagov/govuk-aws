## Project: infra-s3-mirrors

This creates two s3 buckets

govuk-mirror-{env}-access-logs: The bucket that will hold the access logs
govuk-mirror-{env}: The bucket that will hold the mirror content



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| stackname | Stackname | string | - | yes |

