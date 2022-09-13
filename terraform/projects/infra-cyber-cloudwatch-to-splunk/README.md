## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.25 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.25 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_subscription_filter.log_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_cloudwatch_log_subscription_filter.log_subscription_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_splunk_destination_arn"></a> [splunk\_destination\_arn](#input\_splunk\_destination\_arn) | The ARN of Cyber Security's centralised security logging service (https://github.com/alphagov/centralised-security-logging-service) | `string` | n/a | yes |
| <a name="input_splunk_destination_v2_arn"></a> [splunk\_destination\_v2\_arn](#input\_splunk\_destination\_v2\_arn) | The ARN of v2 of Cyber Security's centralised security logging service (https://github.com/alphagov/centralised-security-logging-service) | `string` | n/a | yes |

## Outputs

No outputs.
