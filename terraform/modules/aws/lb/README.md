## Modules: aws/lb

This module creates a Load Balancer resource, with associated
listeners and target groups.

Listeners and target groups are defined with map variables,
where the key is the name of the resource, and the value is
the port and protocol of the resource, specified as `PROTOCOL:PORT`.

Listeners are associated to target groups with the `listener_target_groups`
map, that uses the name of the resources.

When using a listener on HTTPS, we can specify the certificate with
the `listener_certificates` variable, where the value is the domain name
of the certificate as registered on AWS. The value is used by an
`aws_acm_certificate` data resource to find the certificate ARN.

```
listeners = {
  "myapp-http-80"   = "HTTP:80"
  "myapp-https-443" = "HTTPS:443"
}

target_groups = {
  "http-80" = "HTTP:80"
}

listener_target_groups = {
  "myapp-http-80"   = "http-80"
  "myapp-https-443" = "http-80"
}

listener_certificates = {
  "myapp-https-443" = "mydomain.com"
}

```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| access_logs_bucket_name | The S3 bucket name to store the logs in. | string | - | yes |
| default_tags | Additional resource tags | map | `<map>` | no |
| internal | If true, the LB will be internal. | string | `true` | no |
| listener_certificates | A map of Load Balancer Listener certificate domain names. | map | - | yes |
| listener_target_groups | A map matching Load Balancer Listeners and Target groups | map | - | yes |
| listeners | A map of Load Balancer Listener resources. | map | - | yes |
| load_balancer_type | The type of load balancer to create. Possible values are application or network. The default value is application. | string | `application` | no |
| name | The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters. | string | - | yes |
| security_groups | A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application. | list | `<list>` | no |
| subnets | A list of subnet IDs to attach to the LB. | list | - | yes |
| target_group_deregistration_delay | The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. | string | `300` | no |
| target_group_health_check_interval | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. | string | `30` | no |
| target_group_health_check_timeout | The amount of time, in seconds, during which no response means a failed health check. | string | `5` | no |
| target_groups | A map of Load Balancer Target group resources. | map | - | yes |
| vpc_id | The ID of the VPC in which the target groups are created. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| lb_arn_suffix | The ARN suffix for use with CloudWatch Metrics. |
| lb_dns_name | The DNS name of the load balancer. |
| lb_id | The ARN of the load balancer (matches arn). |
| lb_zone_id | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |

