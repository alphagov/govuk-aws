## Project: app-rabbitmq

Rabbitmq cluster

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| null | n/a |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| federation | Whether we do RabbitMQ federation or not | `string` | `"false"` | no |
| instance\_ami\_filter\_name | Name to use to find AMI images | `string` | `""` | no |
| instance\_type | Instance type used for EC2 resources | `string` | `"t2.medium"` | no |
| internal\_domain\_name | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| internal\_zone\_name | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| rabbitmq\_1\_ip | IP address of the private IP to assign to the instance | `string` | `""` | no |
| rabbitmq\_1\_reserved\_ips\_subnet | Name of the subnet to place the reserved IP of the instance | `string` | `""` | no |
| rabbitmq\_2\_ip | IP address of the private IP to assign to the instance | `string` | `""` | no |
| rabbitmq\_2\_reserved\_ips\_subnet | Name of the subnet to place the reserved IP of the instance | `string` | `""` | no |
| rabbitmq\_3\_ip | IP address of the private IP to assign to the instance | `string` | `""` | no |
| rabbitmq\_3\_reserved\_ips\_subnet | Name of the subnet to place the reserved IP of the instance | `string` | `""` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
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
| rabbitmq\_internal\_service\_dns\_name | DNS name to access the rabbitmq internal service |

