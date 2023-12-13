## Project: app-ci-master

CI Master Node

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.15 |
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
| <a name="module_alarms-elb-ci-master-external"></a> [alarms-elb-ci-master-external](#module\_alarms-elb-ci-master-external) | ../../modules/aws/alarms/elb | n/a |
| <a name="module_ci-master"></a> [ci-master](#module\_ci-master) | ../../modules/aws/node_group | n/a |
| <a name="module_ci_master_public_lb"></a> [ci\_master\_public\_lb](#module\_ci\_master\_public\_lb) | ../../modules/aws/lb | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.ci_master_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_ebs_volume.ci-master](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) | resource |
| [aws_elb.ci-master_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_elb.ci-master_internal_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_iam_policy.ci-master_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.ci-master_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_record.ci_master_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.ci_master_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.service_record_internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_shield_protection.ci_master_public_lb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/shield_protection) | resource |
| [null_resource.user_data](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_acm_certificate.elb_external_cert](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/acm_certificate) | data source |
| [aws_acm_certificate.elb_internal_cert](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/acm_certificate) | data source |
| [aws_autoscaling_groups.ci_master](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_route53_zone.external](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) | data source |
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
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_create_external_elb"></a> [create\_external\_elb](#input\_create\_external\_elb) | Create the external ELB | `bool` | `true` | no |
| <a name="input_deploy_subnet"></a> [deploy\_subnet](#input\_deploy\_subnet) | Name of the subnet to place the ci and EBS volume | `string` | n/a | yes |
| <a name="input_ebs_encrypted"></a> [ebs\_encrypted](#input\_ebs\_encrypted) | Whether or not the EBS volume is encrypted | `string` | n/a | yes |
| <a name="input_elb_external_certname"></a> [elb\_external\_certname](#input\_elb\_external\_certname) | The ACM cert domain name to find the ARN of, will be attached to external classic ELB | `string` | n/a | yes |
| <a name="input_elb_internal_certname"></a> [elb\_internal\_certname](#input\_elb\_internal\_certname) | The ACM cert domain name to find the ARN of, will be attached to internal classic ELB | `string` | n/a | yes |
| <a name="input_elb_public_certname"></a> [elb\_public\_certname](#input\_elb\_public\_certname) | The ACM cert domain name to find the ARN of, will be attached to external ALB | `string` | n/a | yes |
| <a name="input_elb_public_secondary_certname"></a> [elb\_public\_secondary\_certname](#input\_elb\_public\_secondary\_certname) | The ACM secondary cert domain name to find the ARN of, will be attached to external ALB | `string` | `""` | no |
| <a name="input_esm_trusty_token"></a> [esm\_trusty\_token](#input\_esm\_trusty\_token) | n/a | `string` | n/a | yes |
| <a name="input_external_domain_name"></a> [external\_domain\_name](#input\_external\_domain\_name) | The domain name of the external DNS records, it could be different from the zone name | `string` | n/a | yes |
| <a name="input_external_zone_name"></a> [external\_zone\_name](#input\_external\_zone\_name) | The name of the Route53 zone that contains external records | `string` | n/a | yes |
| <a name="input_instance_ami_filter_name"></a> [instance\_ami\_filter\_name](#input\_instance\_ami\_filter\_name) | Name to use to find AMI images | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for EC2 resources | `string` | `"t2.medium"` | no |
| <a name="input_internal_domain_name"></a> [internal\_domain\_name](#input\_internal\_domain\_name) | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| <a name="input_internal_service_names"></a> [internal\_service\_names](#input\_internal\_service\_names) | list of internal names for ci-master, used for DNS domain | `list(string)` | <pre>[<br>  "ci"<br>]</pre> | no |
| <a name="input_internal_zone_name"></a> [internal\_zone\_name](#input\_internal\_zone\_name) | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| <a name="input_public_service_names"></a> [public\_service\_names](#input\_public\_service\_names) | list of public names for ci-master, used for DNS domain | `list(string)` | <pre>[<br>  "ci"<br>]</pre> | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_artefact_bucket_key_stack"></a> [remote\_state\_infra\_artefact\_bucket\_key\_stack](#input\_remote\_state\_infra\_artefact\_bucket\_key\_stack) | Override infra\_artefact\_bucket remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_user_data_snippets"></a> [user\_data\_snippets](#input\_user\_data\_snippets) | List of user-data snippets | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ci-master_elb_dns_name"></a> [ci-master\_elb\_dns\_name](#output\_ci-master\_elb\_dns\_name) | DNS name to access the ci-master service |
