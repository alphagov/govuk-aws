## Project: infra-mirror-bucket

This project creates two s3 buckets: a primary s3 bucket to store the govuk
mirror files and a replica s3 bucket which tracks the primary s3 bucket.

The primary bucket should be in London and the backup in Ireland.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app\_mirrorer\_stackname | Stackname of the app mirrorer | string | n/a | yes |
| aws\_environment | AWS Environment | string | n/a | yes |
| aws\_region | AWS region where primary s3 bucket is located | string | `"eu-west-2"` | no |
| aws\_replica\_region | AWS region where replica s3 bucket is located | string | `"eu-west-1"` | no |
| cloudfront\_assets\_certificate\_domain | The domain of the Assets CloudFront certificate to look up. | string | `""` | no |
| cloudfront\_assets\_distribution\_aliases | Extra CNAMEs \(alternate domain names\), if any, for the Assets CloudFront distribution. | list | `<list>` | no |
| cloudfront\_create | Create Cloudfront resources. | string | `"false"` | no |
| cloudfront\_enable | Enable Cloudfront distributions. | string | `"false"` | no |
| cloudfront\_www\_certificate\_domain | The domain of the WWW CloudFront certificate to look up. | string | `""` | no |
| cloudfront\_www\_distribution\_aliases | Extra CNAMEs \(alternate domain names\), if any, for the WWW CloudFront distribution. | list | `<list>` | no |
| office\_ips | An array of CIDR blocks that will be allowed offsite access. | list | n/a | yes |
| remote\_state\_app\_mirrorer\_key\_stack | stackname path to app\_mirrorer remote state | string | `""` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | string | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | string | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | string | `""` | no |
| stackname | Stackname | string | n/a | yes |

