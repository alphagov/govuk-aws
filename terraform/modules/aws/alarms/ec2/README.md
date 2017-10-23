## Module: aws/alarms/ec2

This module creates the following CloudWatch alarms in the
AWS/EC2 namespace:

  - CPUUtilization greater than or equal to threshold threshold
  - StatusCheckFailed_Instance greater than or equal to 1 (instance status
    check failed)

Alarms are created for all the instances that belong to a given
autoscaling group name. All metrics are measured during a period of 60 seconds
and evaluated during 2 consecutive periods.

AWS/EC2 metrics reference:

http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ec2-metricscollected.html


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm_actions | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | list | - | yes |
| autoscaling_group_name | The name of the AutoScalingGroup that we want to monitor. | string | - | yes |
| cpuutilization_threshold | The value against which the CPUUtilization metric is compared, in percent. | string | `80` | no |
| name_prefix | The alarm name prefix. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| alarm_ec2_cpuutilization_id | The ID of the instance CPUUtilization health check. |
| alarm_ec2_statuscheckfailed_instance_id | The ID of the instance StatusCheckFailed_Instance health check. |

