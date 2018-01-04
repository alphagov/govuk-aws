## Module: aws/alarms/cloudtrail

This module creates CloudWatch alarms in a CloudTrailMetrics
namespace by filtering patterns in the log group configured
for CloudTrail.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm_actions | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | list | - | yes |
| alarm_description | The description for the alarm. | string | `` | no |
| alarm_name | The descriptive name for the alarm. This name must be unique within the user's AWS account. | string | - | yes |
| cloudtrail_log_group_name | The name of the log group to associate the metric filter with. | string | - | yes |
| metric_filter_pattern | A valid CloudWatch Logs filter pattern for extracting metric data out of ingested log events. | string | - | yes |
| metric_name | The name of the CloudWatch metric to which the monitored log information should be published. | string | - | yes |

