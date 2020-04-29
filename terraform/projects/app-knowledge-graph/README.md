## Project: app-knowledge-graph

Knowledge graph

The central knowledge graph which can be used to ask questions of GOV.UK content.

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 1.40.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 1.40.0 |
| template | n/a |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| elb\_external\_certname | The ACM cert domain name to find the ARN of | `string` | n/a | yes |
| external\_domain\_name | The domain name of the external DNS records, it could be different from the zone name | `string` | n/a | yes |
| external\_zone\_name | The name of the Route53 zone that contains external records | `string` | n/a | yes |
| remote\_state\_app\_related\_links\_key\_stack | Override stackname path to app\_related\_links remote state | `string` | `""` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_database\_backups\_bucket\_key\_stack | Override stackname path to infra\_database\_backups\_bucket remote state | `string` | `""` | no |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| stackname | Stackname | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| data-infrastructure-bucket\_name | Bucket to store data for data platform |
| read\_write\_data\_infrastructure\_bucket\_policy\_arn | Policy ARN to read and write to the data-infrastructure-data bucket |

