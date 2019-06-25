## Modules: aws/alarm/alb

This module creates the following CloudWatch alarms in the
AWS/ApplicationELB namespace:

  - HTTPCode_Target_4XX_Count greater than or equal to threshold
  - HTTPCode_Target_5XX_Count greater than or equal to threshold
  - HTTPCode_ELB_4XX_Count greater than or equal to threshold
  - HTTPCode_ELB_5XX_Count greater than or equal to threshold

All metrics are measured during a period of 60 seconds and evaluated
during 5 consecutive periods.

To disable any alarm, set the threshold parameter to 0.

AWS/ApplicationELB metrics reference:

http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/elb-metricscollected.html#load-balancer-metric-dimensions-alb


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm_actions | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | list | `<list>` | no |
| alb_arn_suffix | The ALB ARN suffix for use with CloudWatch Metrics. | string | - | yes |
| httpcode_elb_4xx_count_threshold | The value against which the HTTPCode_ELB_4XX_Count metric is compared. | string | `0` | no |
| httpcode_elb_5xx_count_threshold | The value against which the HTTPCode_ELB_5XX_Count metric is compared. | string | `80` | no |
| httpcode_target_4xx_count_threshold | The value against which the HTTPCode_Target_4XX_Count metric is compared. | string | `0` | no |
| httpcode_target_5xx_count_threshold | The value against which the HTTPCode_Target_5XX_Count metric is compared. | string | `80` | no |
| name_prefix | The alarm name prefix. | string | - | yes |

