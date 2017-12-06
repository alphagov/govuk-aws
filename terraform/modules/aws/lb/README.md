## Modules: aws/lb

This module creates a Load Balancer resource, with associated
listeners and default target groups, and CloudWatch alarms

The listeners and default actions are configured in the `listener_action`
map. The keys are the listeners PROTOCOL:PORT parameters, and the values
are the PROTOCOL:PORT parameters of the default target group of that listener.

```
listener_action = {
  "HTTP:80"   = "HTTP:8080"
  "HTTPS:443" = "HTTP:8080"
}
```

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
| access_logs_bucket_name | The S3 bucket name to store the logs in. | string | - | yes |
| access_logs_bucket_prefix | The S3 prefix name to store the logs in. | string | `` | no |
| alarm_actions | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | list | `<list>` | no |
| default_tags | Additional resource tags | map | `<map>` | no |
| httpcode_elb_4xx_count_threshold | The value against which the HTTPCode_ELB_4XX_Count metric is compared. | string | `0` | no |
| httpcode_elb_5xx_count_threshold | The value against which the HTTPCode_ELB_5XX_Count metric is compared. | string | `80` | no |
| httpcode_target_4xx_count_threshold | The value against which the HTTPCode_Target_4XX_Count metric is compared. | string | `0` | no |
| httpcode_target_5xx_count_threshold | The value against which the HTTPCode_Target_5XX_Count metric is compared. | string | `80` | no |
| internal | If true, the LB will be internal. | string | `true` | no |
| listener_action | A map of Load Balancer Listener and default target group action, both specified as PROTOCOL:PORT. | map | - | yes |
| listener_certificate_domain_name | HTTPS Listener certificate domain name. | string | `` | no |
| listener_ssl_policy | The name of the SSL Policy for HTTPS listeners. | string | `ELBSecurityPolicy-2015-05` | no |
| load_balancer_type | The type of load balancer to create. Possible values are application or network. The default value is application. | string | `application` | no |
| name | The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters. | string | - | yes |
| security_groups | A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application. | list | `<list>` | no |
| subnets | A list of subnet IDs to attach to the LB. | list | - | yes |
| target_group_deregistration_delay | The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. | string | `300` | no |
| target_group_health_check_interval | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. | string | `30` | no |
| target_group_health_check_path | The health check path. | string | `/_healthcheck` | no |
| target_group_health_check_timeout | The amount of time, in seconds, during which no response means a failed health check. | string | `5` | no |
| vpc_id | The ID of the VPC in which the default target groups are created. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| lb_arn_suffix | The ARN suffix for use with CloudWatch Metrics. |
| lb_dns_name | The DNS name of the load balancer. |
| lb_id | The ARN of the load balancer (matches arn). |
| lb_zone_id | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |
| target_group_arns | List of the default target group ARNs. |

