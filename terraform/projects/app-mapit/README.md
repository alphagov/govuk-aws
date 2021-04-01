## Project: app-mapit

Mapit node

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alarms-elb-mapit-internal"></a> [alarms-elb-mapit-internal](#module\_alarms-elb-mapit-internal) | ../../modules/aws/alarms/elb |  |
| <a name="module_mapit-1"></a> [mapit-1](#module\_mapit-1) | ../../modules/aws/node_group |  |
| <a name="module_mapit-2"></a> [mapit-2](#module\_mapit-2) | ../../modules/aws/node_group |  |
| <a name="module_mapit-3"></a> [mapit-3](#module\_mapit-3) | ../../modules/aws/node_group |  |
| <a name="module_mapit-4"></a> [mapit-4](#module\_mapit-4) | ../../modules/aws/node_group |  |

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.mapit-1](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.mapit-2](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.mapit-3](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.mapit-4](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_elasticache_cluster.memcached](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_subnet_group.memcached](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elasticache_subnet_group) | resource |
| [aws_elb.mapit_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_iam_policy.mapit_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.mapit_1_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.mapit_2_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.mapit_3_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.mapit_4_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_record.mapit_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.memcached_cname](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [null_resource.user_data](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_acm_certificate.elb_internal_cert](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/acm_certificate) | data source |
| [aws_route53_zone.internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) | data source |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_stack_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_ebs_device_name"></a> [ebs\_device\_name](#input\_ebs\_device\_name) | Name of the block device to mount on the instance, e.g. xvdf | `string` | n/a | yes |
| <a name="input_ebs_device_volume_size"></a> [ebs\_device\_volume\_size](#input\_ebs\_device\_volume\_size) | Size of additional ebs volume in GB | `string` | `"20"` | no |
| <a name="input_ebs_encrypted"></a> [ebs\_encrypted](#input\_ebs\_encrypted) | Whether or not the EBS volume is encrypted | `string` | n/a | yes |
| <a name="input_elb_internal_certname"></a> [elb\_internal\_certname](#input\_elb\_internal\_certname) | The ACM cert domain name to find the ARN of | `string` | n/a | yes |
| <a name="input_instance_ami_filter_name"></a> [instance\_ami\_filter\_name](#input\_instance\_ami\_filter\_name) | Name to use to find AMI images | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for EC2 resources | `string` | `"c5.2xlarge"` | no |
| <a name="input_internal_domain_name"></a> [internal\_domain\_name](#input\_internal\_domain\_name) | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| <a name="input_internal_zone_name"></a> [internal\_zone\_name](#input\_internal\_zone\_name) | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| <a name="input_lc_create_ebs_volume"></a> [lc\_create\_ebs\_volume](#input\_lc\_create\_ebs\_volume) | Creates a launch configuration which will add an additional ebs volume to the instance if this value is set to 1 | `string` | n/a | yes |
| <a name="input_mapit_subnet_a"></a> [mapit\_subnet\_a](#input\_mapit\_subnet\_a) | Name of the subnet to place the first third of mapit instances and EBS volumes | `string` | n/a | yes |
| <a name="input_mapit_subnet_b"></a> [mapit\_subnet\_b](#input\_mapit\_subnet\_b) | Name of the subnet to place the second third of mapit instances and EBS volumes | `string` | n/a | yes |
| <a name="input_mapit_subnet_c"></a> [mapit\_subnet\_c](#input\_mapit\_subnet\_c) | Name of the subnet to place the last third of mapit instances and EBS volumes | `string` | n/a | yes |
| <a name="input_memcached_instance_type"></a> [memcached\_instance\_type](#input\_memcached\_instance\_type) | Instance type used for the shared Elasticache Memcached instances | `string` | `"cache.m6g.large"` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_user_data_snippets"></a> [user\_data\_snippets](#input\_user\_data\_snippets) | List of user-data snippets | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mapit_service_dns_name"></a> [mapit\_service\_dns\_name](#output\_mapit\_service\_dns\_name) | DNS name to access the mapit internal service |
