## Project: datagovuk-organogram-bucket

This creates an s3 bucket

datagovuk-organogram-bucket: A bucket to hold data.gov.uk organogram files

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| fastly | n/a |
| terraform | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) |
| [aws_iam_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) |
| [aws_iam_user](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) |
| [aws_s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket_policy) |
| [fastly_ip_ranges](https://registry.terraform.io/providers/hashicorp/fastly/latest/docs/data-sources/ip_ranges) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| domain | The domain of the data.gov.uk service to manage | `string` | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| stackname | Stackname | `string` | n/a | yes |

## Outputs

No output.
