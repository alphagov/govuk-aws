## Project: app-shared-documentdb

Shared DocumentDB to support the following apps:  
  1. asset-manager

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_environment | AWS environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| backup\_retention\_period | Retention period in days for DocumentDB automatic snapshots | `string` | `"1"` | no |
| instance\_count | Instance count used for DocumentDB resources | `string` | `"3"` | no |
| instance\_type | Instance type used for DocumentDB resources | `string` | `"db.r5.large"` | no |
| master\_password | Password of master user on DocumentDB cluster | `string` | n/a | yes |
| master\_username | Username of master user on DocumentDB cluster | `string` | n/a | yes |
| profiler | Whether to log slow queries to CloudWatch. Must be either 'enabled' or 'disabled'. | `string` | `"enabled"` | no |
| profiler\_threshold\_ms | Queries which take longer than this number of milliseconds are logged to CloudWatch if profiler is enabled. Minimum is 50. | `string` | `"300"` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_key\_stack | Override infra\_security stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| stackname | Stackname | `string` | n/a | yes |
| tls | Whether to enable or disable TLS for the DocumentDB cluster. Must be either 'enabled' or 'disabled'. | `string` | `"disabled"` | no |

## Outputs

| Name | Description |
|------|-------------|
| shared\_documentdb\_endpoint | The endpoint of the shared DocumentDB |

