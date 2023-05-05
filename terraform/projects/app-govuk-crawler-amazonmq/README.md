## Project: app-govuk-crawler-amazonmq

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
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_mq_broker.govuk_crawler_amazonmq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | resource |
| [aws_security_group_rule.govukcrawleramazonmq_ingress_management_amqps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.govukcrawleramazonmq_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_password.govuk_crawler_worker](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.monitoring](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.root](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_deployment_mode"></a> [deployment\_mode](#input\_deployment\_mode) | SINGLE\_INSTANCE, ACTIVE\_STANDBY\_MULTI\_AZ, or CLUSTER\_MULTI\_AZ | `string` | `"SINGLE_INSTANCE"` | no |
| <a name="input_engine_type"></a> [engine\_type](#input\_engine\_type) | Type of broker engine. Either ActiveMQ or RabbitMQ | `string` | `"RabbitMQ"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Version of the broker engine | `string` | `"3.9.16"` | no |
| <a name="input_govuk_crawler_amazonmq_broker_name"></a> [govuk\_crawler\_amazonmq\_broker\_name](#input\_govuk\_crawler\_amazonmq\_broker\_name) | Unique name given to the broker, and the first part of the internal domain name. Must be a valid domain part (i.e. stick to a-z, 0-9, and - as a separator, no spaces). | `string` | `"govukCrawlerMQ"` | no |
| <a name="input_host_instance_type"></a> [host\_instance\_type](#input\_host\_instance\_type) | Broker's instance type. For example, mq.t3.micro, mq.m5.large | `string` | `"mq.t3.micro"` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Whether to enable connections from applications outside of the VPC that hosts the broker's subnets. Default false | `bool` | `false` | no |

## Outputs

No outputs.
