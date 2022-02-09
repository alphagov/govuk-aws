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
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.elb_httpcode_elb_4xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.elb_httpcode_elb_5xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.elb_httpcode_target_4xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.elb_httpcode_target_5xx_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.listener_non_ssl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_certificate.internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate) | resource |
| [aws_lb_listener_certificate.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate) | resource |
| [aws_lb_target_group.tg_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_acm_certificate.internal_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_acm_certificate.secondary_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [null_data_source.values](https://registry.terraform.io/providers/hashicorp/null/latest/docs/data-sources/data_source) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_bucket_name"></a> [access\_logs\_bucket\_name](#input\_access\_logs\_bucket\_name) | The S3 bucket name to store the logs in. | `string` | n/a | yes |
| <a name="input_access_logs_bucket_prefix"></a> [access\_logs\_bucket\_prefix](#input\_access\_logs\_bucket\_prefix) | The S3 prefix name to store the logs in. | `string` | `""` | no |
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | The list of actions to execute when this alarm transitions into an ALARM state. Each action is specified as an Amazon Resource Number (ARN). | `list` | `[]` | no |
| <a name="input_allow_routing_for_absent_host_header_rules"></a> [allow\_routing\_for\_absent\_host\_header\_rules](#input\_allow\_routing\_for\_absent\_host\_header\_rules) | If true, the ALB will route to backend hosts. Otherwise, a 400 error will be returned | `string` | `"true"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Additional resource tags | `map` | `{}` | no |
| <a name="input_httpcode_elb_4xx_count_threshold"></a> [httpcode\_elb\_4xx\_count\_threshold](#input\_httpcode\_elb\_4xx\_count\_threshold) | The value against which the HTTPCode\_ELB\_4XX\_Count metric is compared. | `string` | `"0"` | no |
| <a name="input_httpcode_elb_5xx_count_threshold"></a> [httpcode\_elb\_5xx\_count\_threshold](#input\_httpcode\_elb\_5xx\_count\_threshold) | The value against which the HTTPCode\_ELB\_5XX\_Count metric is compared. | `string` | `"80"` | no |
| <a name="input_httpcode_target_4xx_count_threshold"></a> [httpcode\_target\_4xx\_count\_threshold](#input\_httpcode\_target\_4xx\_count\_threshold) | The value against which the HTTPCode\_Target\_4XX\_Count metric is compared. | `string` | `"0"` | no |
| <a name="input_httpcode_target_5xx_count_threshold"></a> [httpcode\_target\_5xx\_count\_threshold](#input\_httpcode\_target\_5xx\_count\_threshold) | The value against which the HTTPCode\_Target\_5XX\_Count metric is compared. | `string` | `"80"` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle. | `string` | `"60"` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | If true, the LB will be internal. | `string` | `true` | no |
| <a name="input_listener_action"></a> [listener\_action](#input\_listener\_action) | A map of Load Balancer Listener and default target group action, both specified as PROTOCOL:PORT. | `map` | n/a | yes |
| <a name="input_listener_certificate_domain_name"></a> [listener\_certificate\_domain\_name](#input\_listener\_certificate\_domain\_name) | HTTPS Listener certificate domain name. | `string` | `""` | no |
| <a name="input_listener_internal_certificate_domain_name"></a> [listener\_internal\_certificate\_domain\_name](#input\_listener\_internal\_certificate\_domain\_name) | HTTPS Listener internal certificate domain name. | `string` | `""` | no |
| <a name="input_listener_secondary_certificate_domain_name"></a> [listener\_secondary\_certificate\_domain\_name](#input\_listener\_secondary\_certificate\_domain\_name) | HTTPS Listener secondary certificate domain name. | `string` | `""` | no |
| <a name="input_listener_ssl_policy"></a> [listener\_ssl\_policy](#input\_listener\_ssl\_policy) | The name of the SSL Policy for HTTPS listeners. | `string` | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | The type of load balancer to create. Possible values are application or network. The default value is application. | `string` | `"application"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters. | `string` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application. | `list` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A list of subnet IDs to attach to the LB. | `list` | n/a | yes |
| <a name="input_target_group_deregistration_delay"></a> [target\_group\_deregistration\_delay](#input\_target\_group\_deregistration\_delay) | The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. | `string` | `300` | no |
| <a name="input_target_group_health_check_interval"></a> [target\_group\_health\_check\_interval](#input\_target\_group\_health\_check\_interval) | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. | `string` | `30` | no |
| <a name="input_target_group_health_check_matcher"></a> [target\_group\_health\_check\_matcher](#input\_target\_group\_health\_check\_matcher) | The health check match response code. | `string` | `"200"` | no |
| <a name="input_target_group_health_check_path"></a> [target\_group\_health\_check\_path](#input\_target\_group\_health\_check\_path) | The health check path. | `string` | `"/_healthcheck"` | no |
| <a name="input_target_group_health_check_timeout"></a> [target\_group\_health\_check\_timeout](#input\_target\_group\_health\_check\_timeout) | The amount of time, in seconds, during which no response means a failed health check. | `string` | `5` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC in which the default target groups are created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_arn_suffix"></a> [lb\_arn\_suffix](#output\_lb\_arn\_suffix) | The ARN suffix for use with CloudWatch Metrics. |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | The DNS name of the load balancer. |
| <a name="output_lb_id"></a> [lb\_id](#output\_lb\_id) | The ARN of the load balancer (matches arn). |
| <a name="output_lb_zone_id"></a> [lb\_zone\_id](#output\_lb\_zone\_id) | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |
| <a name="output_load_balancer_ssl_listeners"></a> [load\_balancer\_ssl\_listeners](#output\_load\_balancer\_ssl\_listeners) | List of https listeners on the Load Balancer. |
| <a name="output_target_group_arns"></a> [target\_group\_arns](#output\_target\_group\_arns) | List of the default target group ARNs. |
