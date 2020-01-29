## Project: app-licensify-documentdb

DocumentDB cluster for Licensify

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
| instance\_count | Instance count used for Licensify DocumentDB resources | `string` | `"3"` | no |
| instance\_type | Instance type used for Licensify DocumentDB resources | `string` | `"db.r5.large"` | no |
| master\_password | Password of master user on Licensify DocumentDB cluster | `string` | n/a | yes |
| master\_username | Username of master user on Licensify DocumentDB cluster | `string` | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_key\_stack | Override infra\_security stackname path to infra\_vpc remote state | `string` | `""` | no |
| stackname | Stackname | `string` | n/a | yes |
| tls | Whether to enable or disable TLS for the Licensify DocumentDB cluster. Must be either 'enabled' or 'disabled'. | `string` | `"enabled"` | no |

## Outputs

| Name | Description |
|------|-------------|
| licensify\_documentdb\_endpoint | The endpoint of the Licensify DocumentDB |

