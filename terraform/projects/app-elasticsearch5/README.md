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
| aws_environment | AWS Environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_root_dns_zones_key_stack | Override stackname path to infra_root_dns_zones remote state | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_stack_dns_zones remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| stackname | Stackname | string | - | yes |

