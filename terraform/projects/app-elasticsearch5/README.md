## Project: app-elasticsearch5

Managed Elasticsearch 5 cluster

This project has two gotchas, where we work around things terraform
doesn't support:

- Deploying the cluster across 3 availability zones: terraform has
  some built-in validation which rejects using 3 master nodes and 3
  data nodes across 3 availability zones.  To provision a new
  cluster, only use two of everything, then bump the numbers in the
  AWS console and in the terraform variables - it won't complain
  when you next plan.

  https://github.com/terraform-providers/terraform-provider-aws/issues/7504

- Configuring a snapshot repository: terraform doesn't support this,
  and as far as I can tell doesn't have any plans to.  There's a
  Python script in this directory which sets those up.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_environment | AWS Environment | string | n/a | yes |
| aws\_region | AWS region | string | `"eu-west-1"` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | string | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | string | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | string | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | string | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | string | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | string | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | string | `""` | no |
| stackname | Stackname | string | n/a | yes |

