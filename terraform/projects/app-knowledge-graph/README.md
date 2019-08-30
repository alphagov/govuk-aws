## Project: app-knowledge-graph

Knowledge graph

The central knowledge graph which can be used to ask questions of GOV.UK content.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| elb_external_certname | The ACM cert domain name to find the ARN of | string | - | yes |
| external_domain_name | The domain name of the external DNS records, it could be different from the zone name | string | - | yes |
| external_zone_name | The name of the Route53 zone that contains external records | string | - | yes |
| remote_state_app_related_links_key_stack | Override stackname path to app_related_links remote state | string | `` | no |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_database_backups_bucket_key_stack | Override stackname path to infra_database_backups_bucket remote state | string | `` | no |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_root_dns_zones_key_stack | Override stackname path to infra_root_dns_zones remote state | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_stack_dns_zones remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| stackname | Stackname | string | - | yes |

