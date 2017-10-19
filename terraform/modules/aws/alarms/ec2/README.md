## Module: aws::alarms::ec2

This module creates the following CloudWatch alarms in the
AWS/EC2 namespace:

  - CPUUtilization greater than or equal to threshold threshold, where
    `cpuutilization_threshold` is a given parameter
  - StatusCheckFailed_Instance greater than or equal to 1 (instance status
    check failed)

Alarms are created for all the instances that belong to a given
autoscaling group name.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm_actions | The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Number (ARN). | list | - | yes |
| autoscaling_group_name | The name of the AutoScalingGroup that we want to monitor. | string | - | yes |
| cpuutilization_threshold | The value against which the CPUUtilization metric is compared. Defaults to 80. | string | `80` | no |
| name_prefix | The alarm name prefix. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| alarm_ec2_cpuutilization_id | Outputs -------------------------------------------------------------- |
| alarm_ec2_statuscheckfailed_instance_id | The ID of the instance StatusCheckFailed_Instance health check. |

