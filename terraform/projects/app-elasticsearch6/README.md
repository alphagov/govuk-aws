## Project: app-elasticsearch6

Managed Elasticsearch 6 cluster

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
| cloudwatch_log_retention | Number of days to retain Cloudwatch logs for | string | `90` | no |
| elasticsearch6_dedicated_master_enabled | Indicates whether dedicated master nodes are enabled for the cluster | string | `true` | no |
| elasticsearch6_ebs_encrypt | Whether to encrypt the EBS volume at rest | string | - | yes |
| elasticsearch6_ebs_size | The amount of EBS storage to attach | string | `32` | no |
| elasticsearch6_ebs_type | The type of EBS storage to attach | string | `gp2` | no |
| elasticsearch6_instance_count | The number of ElasticSearch nodes | string | `6` | no |
| elasticsearch6_instance_type | The instance type of the individual ElasticSearch nodes, only instances which allow EBS volumes are supported | string | `r4.xlarge.elasticsearch` | no |
| elasticsearch6_manual_snapshot_bucket_arns | Bucket ARNs this domain can read/write for manual snapshots | list | `<list>` | no |
| elasticsearch6_master_instance_count | Number of dedicated master nodes in the cluster | string | `3` | no |
| elasticsearch6_master_instance_type | Instance type of the dedicated master nodes in the cluster | string | `c4.large.elasticsearch` | no |
| elasticsearch6_snapshot_start_hour | The hour in which the daily snapshot is taken | string | `1` | no |
| elasticsearch_subnet_names | Names of the subnets to place the ElasticSearch domain in | list | - | yes |
| internal_domain_name | The domain name of the internal DNS records, it could be different from the zone name | string | - | yes |
| internal_zone_name | The name of the Route53 zone that contains internal records | string | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_monitoring_key_stack | Override stackname path to infra_monitoring remote state | string | `` | no |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_root_dns_zones_key_stack | Override stackname path to infra_root_dns_zones remote state | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_stack_dns_zones_key_stack | Override stackname path to infra_stack_dns_zones remote state | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| stackname | Stackname | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| domain_configuration_policy_arn | ARN of the policy used to configure the elasticsearch domain |
| manual_snapshots_bucket_arn | ARN of the bucket to store manual snapshots |
| service_dns_name | DNS name to access the Elasticsearch internal service |
| service_endpoint | Endpoint to submit index, search, and upload requests |
| service_role_id | Unique identifier for the service-linked role |
