## Project: app-frontend

Frontend application servers

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app\_service\_records | List of application service names that get traffic via this loadbalancer | list | `<list>` | no |
| asg\_size | The autoscaling groups desired/max/min capacity | string | `"3"` | no |
| aws\_environment | AWS Environment | string | n/a | yes |
| aws\_region | AWS region | string | `"eu-west-1"` | no |
| elb\_internal\_certname | The ACM cert domain name to find the ARN of | string | n/a | yes |
| enable\_alb | Use application specific target groups and healthchecks based on the list of services in the cname variable. | string | `"false"` | no |
| instance\_ami\_filter\_name | Name to use to find AMI images | string | `""` | no |
| instance\_type | Instance type used for EC2 resources | string | `"m5.xlarge"` | no |
| internal\_domain\_name | The domain name of the internal DNS records, it could be different from the zone name | string | n/a | yes |
| internal\_zone\_name | The name of the Route53 zone that contains internal records | string | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | string | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | string | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | string | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | string | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | string | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | string | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | string | `""` | no |
| root\_block\_device\_volume\_size | The size of the instance root volume in gigabytes | string | `"60"` | no |
| stackname | Stackname | string | n/a | yes |
| user\_data\_snippets | List of user-data snippets | list | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| frontend\_elb\_dns\_name | DNS name to access the frontend service |
| service\_dns\_name | DNS name to access the node service |

