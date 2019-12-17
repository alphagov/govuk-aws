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
| access\_logs\_bucket\_name | The S3 bucket name to store the logs in. | string | n/a | yes |
| access\_logs\_bucket\_prefix | The S3 prefix name to store the logs in. | string | `""` | no |
| alarm\_actions | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number \(ARN\). | list | `<list>` | no |
| default\_tags | Additional resource tags | map | `<map>` | no |
| httpcode\_elb\_4xx\_count\_threshold | The value against which the HTTPCode\_ELB\_4XX\_Count metric is compared. | string | `"0"` | no |
| httpcode\_elb\_5xx\_count\_threshold | The value against which the HTTPCode\_ELB\_5XX\_Count metric is compared. | string | `"80"` | no |
| httpcode\_target\_4xx\_count\_threshold | The value against which the HTTPCode\_Target\_4XX\_Count metric is compared. | string | `"0"` | no |
| httpcode\_target\_5xx\_count\_threshold | The value against which the HTTPCode\_Target\_5XX\_Count metric is compared. | string | `"80"` | no |
| internal | If true, the LB will be internal. | string | `"true"` | no |
| listener\_action | A map of Load Balancer Listener and default target group action, both specified as PROTOCOL:PORT. | map | n/a | yes |
| listener\_certificate\_domain\_name | HTTPS Listener certificate domain name. | string | `""` | no |
| listener\_secondary\_certificate\_domain\_name | HTTPS Listener secondary certificate domain name. | string | `""` | no |
| listener\_ssl\_policy | The name of the SSL Policy for HTTPS listeners. | string | `"ELBSecurityPolicy-2016-08"` | no |
| load\_balancer\_type | The type of load balancer to create. Possible values are application or network. The default value is application. | string | `"application"` | no |
| name | The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters. | string | n/a | yes |
| security\_groups | A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application. | list | `<list>` | no |
| subnets | A list of subnet IDs to attach to the LB. | list | n/a | yes |
| target\_group\_deregistration\_delay | The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. | string | `"300"` | no |
| target\_group\_health\_check\_interval | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. | string | `"30"` | no |
| target\_group\_health\_check\_matcher | The health check match response code. | string | `"200"` | no |
| target\_group\_health\_check\_path | The health check path. | string | `"/_healthcheck"` | no |
| target\_group\_health\_check\_timeout | The amount of time, in seconds, during which no response means a failed health check. | string | `"5"` | no |
| vpc\_id | The ID of the VPC in which the default target groups are created. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| lb\_arn\_suffix | The ARN suffix for use with CloudWatch Metrics. |
| lb\_dns\_name | The DNS name of the load balancer. |
| lb\_id | The ARN of the load balancer \(matches arn\). |
| lb\_zone\_id | The canonical hosted zone ID of the load balancer \(to be used in a Route 53 Alias record\). |
| load\_balancer\_ssl\_listeners | List of https listeners on the Load Balancer. |
| target\_group\_arns | List of the default target group ARNs. |

