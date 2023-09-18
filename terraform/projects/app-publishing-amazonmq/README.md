## Project: app-publishing-amazonmq

Project app-publishing-amazonmq creates an Amazon MQ instance or cluster for GOV.UK.
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
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_dns"></a> [dns](#provider\_dns) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.2.3 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.post_config_to_amazonmq_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.post_config_to_amazonmq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lb.publishingmq_lb_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.internal_amqps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.internal_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.internal_amqps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.internal_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.internal_amqps_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.internal_https_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_mq_broker.publishing_amazonmq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | resource |
| [aws_route53_record.publishing_amazonmq_internal_root_domain_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group_rule.publishingamazonmq_ingress_lb_amqps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.publishingamazonmq_ingress_lb_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.publishingamazonmq_ingress_management_amqps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.publishingamazonmq_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rabbitmq_egress_self_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [local_sensitive_file.amazonmq_rabbitmq_definitions](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [random_password.content_data_api](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.email_alert_service](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.monitoring](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.publishing_api](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.root](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.search_api](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.search_api_v2](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.artefact_lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_acm_certificate.internal_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_iam_policy.lambda_vpc_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_lambda_invocation.post_config_to_amazonmq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lambda_invocation) | data source |
| [aws_subnet.lb_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [dns_a_record_set.mq_instances](https://registry.terraform.io/providers/hashicorp/dns/latest/docs/data-sources/a_record_set) | data source |
| [local_sensitive_file.amazonmq_rabbitmq_definitions_interpolated](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/sensitive_file) | data source |
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
| <a name="input_deployment_mode"></a> [deployment\_mode](#input\_deployment\_mode) | SINGLE\_INSTANCE, ACTIVE\_STANDBY\_MULTI\_AZ, or CLUSTER\_MULTI\_AZ | `string` | `"SINGLE_INSTANCE"` | no |
| <a name="input_elb_internal_certname"></a> [elb\_internal\_certname](#input\_elb\_internal\_certname) | The ACM cert domain name to find the ARN of, so that it can be applied to the Network Load Balancer | `string` | n/a | yes |
| <a name="input_engine_type"></a> [engine\_type](#input\_engine\_type) | ActiveMQ or RabbitMQ | `string` | `"RabbitMQ"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | broker engine version | `string` | `"3.9.16"` | no |
| <a name="input_host_instance_type"></a> [host\_instance\_type](#input\_host\_instance\_type) | Broker's instance type. For example, mq.t3.micro, mq.m5.large | `string` | `"mq.t3.micro"` | no |
| <a name="input_lb_delete_protection"></a> [lb\_delete\_protection](#input\_lb\_delete\_protection) | Whether to enable delete protection on the Network Load Balancer. Defaults to false. | `bool` | `false` | no |
| <a name="input_maintenance_window_start_time_day_of_week"></a> [maintenance\_window\_start\_time\_day\_of\_week](#input\_maintenance\_window\_start\_time\_day\_of\_week) | Day of the week of the start of the maintenance window | `string` | `"WEDNESDAY"` | no |
| <a name="input_maintenance_window_start_time_time_of_day"></a> [maintenance\_window\_start\_time\_time\_of\_day](#input\_maintenance\_window\_start\_time\_time\_of\_day) | Time of day of the start of the maintenance window | `string` | `"07:00"` | no |
| <a name="input_maintenance_window_start_time_time_zone"></a> [maintenance\_window\_start\_time\_time\_zone](#input\_maintenance\_window\_start\_time\_time\_zone) | Time zone of the start of the maintenance window | `string` | `"UTC"` | no |
| <a name="input_office_ips"></a> [office\_ips](#input\_office\_ips) | An array of CIDR blocks that will be allowed offsite access. | `list(any)` | n/a | yes |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Whether to enable connections from applications outside of the VPC that hosts the broker's subnets. Default false | `bool` | `false` | no |
| <a name="input_publishing_amazonmq_broker_name"></a> [publishing\_amazonmq\_broker\_name](#input\_publishing\_amazonmq\_broker\_name) | Unique name given to the broker, and the first part of the internal domain name. Must be a valid domain part (i.e. stick to a-z, 0-9, and - as a separator, no spaces). | `string` | `"PublishingMQ"` | no |
| <a name="input_publishing_amazonmq_instance_count"></a> [publishing\_amazonmq\_instance\_count](#input\_publishing\_amazonmq\_instance\_count) | Number of instances the broker has/should have. This would normally be 1 for a deployment\_mode of SINGLE\_INSTANCE, 2 for ACTIVE\_STANDBY\_MULTI\_AZ, 3 for CLUSTER\_MULTI\_AZ. Defaults to 1. | `number` | `1` | no |
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
| <a name="output_internal_domain_name"></a> [internal\_domain\_name](#output\_internal\_domain\_name) | Persistent internal domain name for the broker. Use this as the hostname for RabbitMQ connection strings in client apps. |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | Name of the Lambda function which posts config to AmazonMQ after creation |
| <a name="output_lambda_function_result"></a> [lambda\_function\_result](#output\_lambda\_function\_result) | n/a |
| <a name="output_publishing_amazonmq_passwords"></a> [publishing\_amazonmq\_passwords](#output\_publishing\_amazonmq\_passwords) | Generated passwords for each RabbitMQ user account. Use `terraform output -json | jq '.publishing_amazonmq_passwords.value'` to retrieve the values. |
