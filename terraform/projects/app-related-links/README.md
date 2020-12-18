## Project: app-related-links

Related Links

Run resource intensive scripts for data science purposes.

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
| concourse\_aws\_account\_id | AWS account ID which contains the Concourse role | `string` | n/a | yes |
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
| concourse\_role\_name | Name of the role assumed by Concourse |
| policy\_read\_content\_store\_backups\_bucket\_policy\_arn | ARN of the policy used to read content store backups from the database backups bucket |
| policy\_read\_write\_related\_links\_bucket\_policy\_arn | ARN of the policy used to read/write data from/to the related links bucket |

