## Project: infra-mirror-bucket

This project creates two s3 buckets: a primary s3 bucket to store the govuk  
mirror files and a replica s3 bucket which tracks the primary s3 bucket.

The primary bucket should be in London and the backup in Ireland.

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |
| aws | 2.46.0 |
| aws | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 2.46.0 2.46.0 |
| aws.aws\_cloudfront\_certificate | 2.46.0 2.46.0 2.46.0 |
| aws.aws\_replica | 2.46.0 2.46.0 2.46.0 |
| external | n/a |
| fastly | n/a |
| template | n/a |
| terraform | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_acm_certificate](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/acm_certificate) |
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/caller_identity) |
| [aws_cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/cloudfront_distribution) |
| [aws_cloudfront_origin_access_identity](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/cloudfront_origin_access_identity) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) |
| [aws_iam_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) |
| [aws_iam_user](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user) |
| [aws_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lambda_function) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) |
| [aws_s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket_policy) |
| [external_external](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) |
| [fastly_ip_ranges](https://registry.terraform.io/providers/hashicorp/fastly/latest/docs/data-sources/ip_ranges) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_mirrorer\_stackname | Stackname of the app mirrorer | `string` | n/a | yes |
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_integration\_account\_root\_arn | AWS account root ARN for the Integration account | `string` | n/a | yes |
| aws\_region | AWS region where primary s3 bucket is located | `string` | `"eu-west-2"` | no |
| aws\_replica\_region | AWS region where replica s3 bucket is located | `string` | `"eu-west-1"` | no |
| cloudfront\_assets\_certificate\_domain | The domain of the Assets CloudFront certificate to look up. | `string` | `""` | no |
| cloudfront\_assets\_distribution\_aliases | Extra CNAMEs (alternate domain names), if any, for the Assets CloudFront distribution. | `list` | `[]` | no |
| cloudfront\_create | Create Cloudfront resources. | `bool` | `false` | no |
| cloudfront\_enable | Enable Cloudfront distributions. | `bool` | `false` | no |
| cloudfront\_www\_certificate\_domain | The domain of the WWW CloudFront certificate to look up. | `string` | `""` | no |
| cloudfront\_www\_distribution\_aliases | Extra CNAMEs (alternate domain names), if any, for the WWW CloudFront distribution. | `list` | `[]` | no |
| lifecycle\_government\_uploads | Number of days for the lifecycle rule for the mirror in the case where the prefix path is www.gov.uk/government/uploads/ | `string` | `"8"` | no |
| lifecycle\_main | Number of days for the lifecycle rule for the mirror | `string` | `"5"` | no |
| office\_ips | An array of CIDR blocks that will be allowed offsite access. | `list` | n/a | yes |
| remote\_state\_app\_mirrorer\_key\_stack | stackname path to app\_mirrorer remote state | `string` | `""` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| stackname | Stackname | `string` | n/a | yes |

## Outputs

No output.
