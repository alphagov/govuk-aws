## Project: app-ci-master

CI Master Node

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| null | n/a |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| create\_external\_elb | Create the external ELB | `bool` | `true` | no |
| deploy\_subnet | Name of the subnet to place the ci and EBS volume | `string` | n/a | yes |
| ebs\_encrypted | Whether or not the EBS volume is encrypted | `string` | n/a | yes |
| elb\_external\_certname | The ACM cert domain name to find the ARN of, will be attached to external classic ELB | `string` | n/a | yes |
| elb\_internal\_certname | The ACM cert domain name to find the ARN of, will be attached to internal classic ELB | `string` | n/a | yes |
| elb\_public\_certname | The ACM cert domain name to find the ARN of, will be attached to external ALB | `string` | n/a | yes |
| elb\_public\_secondary\_certname | The ACM secondary cert domain name to find the ARN of, will be attached to external ALB | `string` | n/a | yes |
| external\_domain\_name | The domain name of the external DNS records, it could be different from the zone name | `string` | n/a | yes |
| external\_zone\_name | The name of the Route53 zone that contains external records | `string` | n/a | yes |
| instance\_ami\_filter\_name | Name to use to find AMI images | `string` | `""` | no |
| instance\_type | Instance type used for EC2 resources | `string` | `"t2.medium"` | no |
| internal\_domain\_name | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| internal\_service\_names | list of internal names for ci-master, used for DNS domain | `list` | <pre>[<br>  "ci"<br>]</pre> | no |
| internal\_zone\_name | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| public\_service\_names | list of public names for ci-master, used for DNS domain | `list` | <pre>[<br>  "ci"<br>]</pre> | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_artefact\_bucket\_key\_stack | Override infra\_artefact\_bucket remote state path | `string` | `""` | no |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| stackname | Stackname | `string` | n/a | yes |
| user\_data\_snippets | List of user-data snippets | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ci-master\_elb\_dns\_name | DNS name to access the ci-master service |

