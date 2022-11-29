## Project: app-amazonmq

Module app-amazonmq creates an Amazon MQ instance or cluster for GOV.UK.
It uses remote state from the infra-vpc and infra-security-groups modules.

The Terraform provider will only allow us to create a single user, so all
other users must be added from the RabbitMQ web admin UI or REST API.

DO NOT USE IN PRODUCTION YET - this version is integration-only, as it
implicitly assumes a single instance, and will need reworking for a
highly-available cluster setup

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_mq_broker.publishing_amazonmq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | resource |
| [aws_route53_record.amazonmq_internal_root_domain_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.amazonmq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.amazonmq_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.amazonmq_ingress_any_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.amazonmq_ingress_management_amqp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.amazonmq_ingress_management_stomp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_route53_zone.internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_stack_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazonmq_definitions"></a> [amazonmq\_definitions](#input\_amazonmq\_definitions) | JSON definitions exported from existing RabbitMQ web management UI. The root user definition should be removed before use. | `string` | n/a | yes |
| <a name="input_amazonmq_root_password"></a> [amazonmq\_root\_password](#input\_amazonmq\_root\_password) | n/a | `string` | n/a | yes |
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_deployment_mode"></a> [deployment\_mode](#input\_deployment\_mode) | SINGLE\_INSTANCE, ACTIVE\_STANDBY\_MULTI\_AZ, or CLUSTER\_MULTI\_AZ | `string` | `"SINGLE_INSTANCE"` | no |
| <a name="input_engine_type"></a> [engine\_type](#input\_engine\_type) | ActiveMQ or RabbitMQ | `string` | `"RabbitMQ"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | broker engine version | `string` | `"3.9.16"` | no |
| <a name="input_host_instance_type"></a> [host\_instance\_type](#input\_host\_instance\_type) | Broker's instance type. For example, mq.t3.micro, mq.m5.large | `string` | `"mq.t3.micro"` | no |
| <a name="input_internal_domain_name"></a> [internal\_domain\_name](#input\_internal\_domain\_name) | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| <a name="input_internal_zone_name"></a> [internal\_zone\_name](#input\_internal\_zone\_name) | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| <a name="input_office_ips"></a> [office\_ips](#input\_office\_ips) | An array of CIDR blocks that will be allowed offsite access. | `list(any)` | n/a | yes |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Whether to enable connections from applications outside of the VPC that hosts the broker's subnets. Default false | `bool` | `false` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | `"blue"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_amqp_endpoint"></a> [amqp\_endpoint](#output\_amqp\_endpoint) | AMQP URL for connecting a client app to the broker |
| <a name="output_broker_id"></a> [broker\_id](#output\_broker\_id) | AWS-generated unique identifier for the broker |
| <a name="output_console_url"></a> [console\_url](#output\_console\_url) | URL of the RabbitMQ web management UI |
