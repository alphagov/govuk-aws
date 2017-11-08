## Module: projects/infra-stack-sns-alerts

This module creates a SNS topic for alert notifications. It creates
and subscribes a SQS queue for further integration.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_region | AWS region | string | `eu-west-1` | no |
| stackname | Stackname | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| sns_topic_alerts_arn | The ARN of the SNS topic |

