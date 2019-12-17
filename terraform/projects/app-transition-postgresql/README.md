## Project: app-transition-postgresql

RDS Transition PostgreSQL Primary instance

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_environment | AWS Environment | string | n/a | yes |
| aws\_region | AWS region | string | `"eu-west-1"` | no |
| cloudwatch\_log\_retention | Number of days to retain Cloudwatch logs for | string | n/a | yes |
| instance\_type | Instance type used for RDS resources | string | `"db.m4.large"` | no |
| internal\_domain\_name | The domain name of the internal DNS records, it could be different from the zone name | string | n/a | yes |
| internal\_zone\_name | The name of the Route53 zone that contains internal records | string | n/a | yes |
| multi\_az | Enable multi-az. | string | `"true"` | no |
| password | DB password | string | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | string | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | string | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | string | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | string | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | string | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | string | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | string | `""` | no |
| skip\_final\_snapshot | Set to true to NOT create a final snapshot when the cluster is deleted. | string | n/a | yes |
| snapshot\_identifier | Specifies whether or not to create the database from this snapshot | string | `""` | no |
| stackname | Stackname | string | n/a | yes |
| username | PostgreSQL username | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| transition-postgresql-primary\_address | transition-postgresql instance address |
| transition-postgresql-primary\_endpoint | transition-postgresql instance endpoint |
| transition-postgresql-primary\_id | transition-postgresql instance ID |
| transition-postgresql-primary\_resource\_id | transition-postgresql instance resource ID |
| transition-postgresql-standby-address | transition-postgresql replica instance address |
| transition-postgresql-standby-endpoint | transition-postgresql replica instance endpoint |

