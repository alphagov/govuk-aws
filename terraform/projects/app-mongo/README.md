## Project: app-mongo

Mongo hosts

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
| <a name="module_alarms-autoscaling-mongo-1"></a> [alarms-autoscaling-mongo-1](#module\_alarms-autoscaling-mongo-1) | ../../modules/aws/alarms/autoscaling |  |
| <a name="module_alarms-autoscaling-mongo-2"></a> [alarms-autoscaling-mongo-2](#module\_alarms-autoscaling-mongo-2) | ../../modules/aws/alarms/autoscaling |  |
| <a name="module_alarms-autoscaling-mongo-3"></a> [alarms-autoscaling-mongo-3](#module\_alarms-autoscaling-mongo-3) | ../../modules/aws/alarms/autoscaling |  |
| <a name="module_alarms-ec2-mongo-1"></a> [alarms-ec2-mongo-1](#module\_alarms-ec2-mongo-1) | ../../modules/aws/alarms/ec2 |  |
| <a name="module_alarms-ec2-mongo-2"></a> [alarms-ec2-mongo-2](#module\_alarms-ec2-mongo-2) | ../../modules/aws/alarms/ec2 |  |
| <a name="module_alarms-ec2-mongo-3"></a> [alarms-ec2-mongo-3](#module\_alarms-ec2-mongo-3) | ../../modules/aws/alarms/ec2 |  |
| <a name="module_mongo-1"></a> [mongo-1](#module\_mongo-1) | ../../modules/aws/node_group |  |
| <a name="module_mongo-2"></a> [mongo-2](#module\_mongo-2) | ../../modules/aws/node_group |  |
| <a name="module_mongo-3"></a> [mongo-3](#module\_mongo-3) | ../../modules/aws/node_group |  |

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.mongo-1](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.mongo-2](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.mongo-3](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_iam_policy.mongo-iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.integration_read_mongoapi_database_backups_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.integration_read_mongodb_database_backups_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.integration_read_production_mongoapi_database_backups_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.integration_read_production_mongodb_database_backups_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.mongo-1_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.mongo-2_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.mongo-3_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.staging_read_mongoapi_database_backups_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.staging_read_mongodb_database_backups_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.staging_read_production_mongoapi_database_backups_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.staging_read_production_mongodb_database_backups_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.write_mongo_api_database_backups_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.write_mongodb_database_backups_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_network_interface.mongo-1_eni](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/network_interface) | resource |
| [aws_network_interface.mongo-2_eni](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/network_interface) | resource |
| [aws_network_interface.mongo-3_eni](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/network_interface) | resource |
| [aws_route53_record.mongo_1_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.mongo_2_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.mongo_3_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [null_resource.user_data](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_route53_zone.internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) | data source |
| [terraform_remote_state.infra_database_backups_bucket](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_stack_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_ebs_encrypted"></a> [ebs\_encrypted](#input\_ebs\_encrypted) | Whether or not the EBS volume is encrypted | `string` | n/a | yes |
| <a name="input_instance_ami_filter_name"></a> [instance\_ami\_filter\_name](#input\_instance\_ami\_filter\_name) | Name to use to find AMI images | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for EC2 resources | `string` | `"m5.large"` | no |
| <a name="input_internal_domain_name"></a> [internal\_domain\_name](#input\_internal\_domain\_name) | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| <a name="input_internal_zone_name"></a> [internal\_zone\_name](#input\_internal\_zone\_name) | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| <a name="input_mongo_1_ip"></a> [mongo\_1\_ip](#input\_mongo\_1\_ip) | IP address of the private IP to assign to the instance | `string` | n/a | yes |
| <a name="input_mongo_1_reserved_ips_subnet"></a> [mongo\_1\_reserved\_ips\_subnet](#input\_mongo\_1\_reserved\_ips\_subnet) | Name of the subnet to place the reserved IP of the instance | `string` | n/a | yes |
| <a name="input_mongo_1_subnet"></a> [mongo\_1\_subnet](#input\_mongo\_1\_subnet) | Name of the subnet to place the Mongo instance 1 and EBS volume | `string` | n/a | yes |
| <a name="input_mongo_2_ip"></a> [mongo\_2\_ip](#input\_mongo\_2\_ip) | IP address of the private IP to assign to the instance | `string` | n/a | yes |
| <a name="input_mongo_2_reserved_ips_subnet"></a> [mongo\_2\_reserved\_ips\_subnet](#input\_mongo\_2\_reserved\_ips\_subnet) | Name of the subnet to place the reserved IP of the instance | `string` | n/a | yes |
| <a name="input_mongo_2_subnet"></a> [mongo\_2\_subnet](#input\_mongo\_2\_subnet) | Name of the subnet to place the Mongo 2 and EBS volume | `string` | n/a | yes |
| <a name="input_mongo_3_ip"></a> [mongo\_3\_ip](#input\_mongo\_3\_ip) | IP address of the private IP to assign to the instance | `string` | n/a | yes |
| <a name="input_mongo_3_reserved_ips_subnet"></a> [mongo\_3\_reserved\_ips\_subnet](#input\_mongo\_3\_reserved\_ips\_subnet) | Name of the subnet to place the reserved IP of the instance | `string` | n/a | yes |
| <a name="input_mongo_3_subnet"></a> [mongo\_3\_subnet](#input\_mongo\_3\_subnet) | Name of the subnet to place the Mongo 3 and EBS volume | `string` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_database_backups_bucket_key_stack"></a> [remote\_state\_infra\_database\_backups\_bucket\_key\_stack](#input\_remote\_state\_infra\_database\_backups\_bucket\_key\_stack) | Override stackname path to infra\_database\_backups\_bucket remote state | `string` | `""` | no |
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
| <a name="output_mongo_1_service_dns_name"></a> [mongo\_1\_service\_dns\_name](#output\_mongo\_1\_service\_dns\_name) | DNS name to access the Mongo 1 internal service |
| <a name="output_mongo_2_service_dns_name"></a> [mongo\_2\_service\_dns\_name](#output\_mongo\_2\_service\_dns\_name) | DNS name to access the Mongo 2 internal service |
| <a name="output_mongo_3_service_dns_name"></a> [mongo\_3\_service\_dns\_name](#output\_mongo\_3\_service\_dns\_name) | DNS name to access the Mongo 3 internal service |
