## Project: app-graphite

Graphite node

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_environment | AWS Environment | string | n/a | yes |
| aws\_region | AWS region | string | `"eu-west-1"` | no |
| create\_external\_elb | Create the external ELB | string | `"true"` | no |
| ebs\_encrypted | Whether or not the EBS volume is encrypted | string | n/a | yes |
| ebs\_volume\_size | EBS Volume size in GB | string | `"250"` | no |
| elb\_external\_certname | The ACM cert domain name to find the ARN of | string | n/a | yes |
| elb\_internal\_certname | The ACM cert domain name to find the ARN of | string | n/a | yes |
| external\_domain\_name | The domain name of the external DNS records, it could be different from the zone name | string | n/a | yes |
| external\_zone\_name | The name of the Route53 zone that contains external records | string | n/a | yes |
| graphite\_1\_subnet | Name of the subnet to place the Graphite instance 1 and EBS volume | string | n/a | yes |
| instance\_ami\_filter\_name | Name to use to find AMI images | string | `""` | no |
| instance\_type | Instance type used for EC2 resources | string | `"m5.xlarge"` | no |
| internal\_domain\_name | The domain name of the internal DNS records, it could be different from the zone name | string | n/a | yes |
| internal\_zone\_name | The name of the Route53 zone that contains internal records | string | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | string | n/a | yes |
| remote\_state\_infra\_database\_backups\_bucket\_key\_stack | Override stackname path to infra\_database\_backups\_bucket remote state | string | `""` | no |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | string | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | string | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | string | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | string | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | string | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | string | `""` | no |
| stackname | Stackname | string | n/a | yes |
| user\_data\_snippets | List of user-data snippets | list | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| graphite\_external\_elb\_dns\_name | DNS name to access the Graphite external service |
| graphite\_internal\_service\_dns\_name | DNS name to access the Graphite internal service |

