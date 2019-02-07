## Project: fastly-datagovuk

Manages the Fastly service for data.gov.uk


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS Environment | string | - | yes |
| domain | The domain of the data.gov.uk service to manage | string | - | yes |
| fastly_api_key | API key to authenticate with Fastly | string | - | yes |
| logging_aws_access_key_id | IAM key ID with access to put logs into the S3 bucket | string | - | yes |
| logging_aws_secret_access_key | IAM secret key with access to put logs into the S3 bucket | string | - | yes |

