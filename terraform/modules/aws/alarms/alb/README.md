## Modules: aws/alarm/alb

This module creates the following CloudWatch alarms in the
AWS/ApplicationELB namespace:

  - HTTPCode\_Target\_4XX\_Count greater than or equal to threshold
  - HTTPCode\_Target\_5XX\_Count greater than or equal to threshold
  - HTTPCode\_ELB\_4XX\_Count greater than or equal to threshold
  - HTTPCode\_ELB\_5XX\_Count greater than or equal to threshold

All metrics are measured during a period of 60 seconds and evaluated
during 5 consecutive periods.

To disable any alarm, set the threshold parameter to 0.

AWS/ApplicationELB metrics reference:

http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/elb-metricscollected.html#load-balancer-metric-dimensions-alb

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.elb_httpcode_elb_4xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.elb_httpcode_elb_5xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.elb_httpcode_target_4xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.elb_httpcode_target_5xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | `list` | `[]` | no |
| <a name="input_alb_arn_suffix"></a> [alb\_arn\_suffix](#input\_alb\_arn\_suffix) | The ALB ARN suffix for use with CloudWatch Metrics. | `string` | n/a | yes |
| <a name="input_httpcode_elb_4xx_count_threshold"></a> [httpcode\_elb\_4xx\_count\_threshold](#input\_httpcode\_elb\_4xx\_count\_threshold) | The value against which the HTTPCode\_ELB\_4XX\_Count metric is compared. | `string` | `"0"` | no |
| <a name="input_httpcode_elb_5xx_count_threshold"></a> [httpcode\_elb\_5xx\_count\_threshold](#input\_httpcode\_elb\_5xx\_count\_threshold) | The value against which the HTTPCode\_ELB\_5XX\_Count metric is compared. | `string` | `"80"` | no |
| <a name="input_httpcode_target_4xx_count_threshold"></a> [httpcode\_target\_4xx\_count\_threshold](#input\_httpcode\_target\_4xx\_count\_threshold) | The value against which the HTTPCode\_Target\_4XX\_Count metric is compared. | `string` | `"0"` | no |
| <a name="input_httpcode_target_5xx_count_threshold"></a> [httpcode\_target\_5xx\_count\_threshold](#input\_httpcode\_target\_5xx\_count\_threshold) | The value against which the HTTPCode\_Target\_5XX\_Count metric is compared. | `string` | `"80"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The alarm name prefix. | `string` | n/a | yes |

## Outputs

No outputs.
