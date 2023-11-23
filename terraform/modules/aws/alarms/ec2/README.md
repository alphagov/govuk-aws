## Module: aws/alarms/ec2

This module creates the following CloudWatch alarms in the
AWS/EC2 namespace:

  - CPUUtilization greater than or equal to threshold threshold
  - StatusCheckFailed\_Instance greater than or equal to 1 (instance status
    check failed)

Alarms are created for all the instances that belong to a given
autoscaling group name. All metrics are measured during a period of 60 seconds
and evaluated during 2 consecutive periods.

AWS/EC2 metrics reference:

http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ec2-metricscollected.html

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
| [aws_cloudwatch_metric_alarm.ec2_cpuutilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_statuscheckfailed_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | `list(string)` | n/a | yes |
| <a name="input_autoscaling_group_name"></a> [autoscaling\_group\_name](#input\_autoscaling\_group\_name) | The name of the AutoScalingGroup that we want to monitor. | `string` | n/a | yes |
| <a name="input_cpuutilization_threshold"></a> [cpuutilization\_threshold](#input\_cpuutilization\_threshold) | The value against which the CPUUtilization metric is compared, in percent. | `string` | `"80"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The alarm name prefix. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_ec2_cpuutilization_id"></a> [alarm\_ec2\_cpuutilization\_id](#output\_alarm\_ec2\_cpuutilization\_id) | The ID of the instance CPUUtilization health check. |
| <a name="output_alarm_ec2_statuscheckfailed_instance_id"></a> [alarm\_ec2\_statuscheckfailed\_instance\_id](#output\_alarm\_ec2\_statuscheckfailed\_instance\_id) | The ID of the instance StatusCheckFailed\_Instance health check. |
