## Project: app-prometheus

Prometheus node

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| null | n/a |
| terraform | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| prometheus-1 | ../../modules/aws/node_group |  |
| prometheus_internal_alb | ../../modules/aws/lb |  |

## Resources

| Name |
|------|
| [aws_acm_certificate](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/acm_certificate) |
| [aws_autoscaling_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) |
| [aws_ebs_volume](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) |
| [aws_lb_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lb_listener_rule) |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| elb\_internal\_certname | The ACM cert domain name (e.g. *.production.govuk-internal.digital) to find the ARN of | `string` | n/a | yes |
| instance\_ami\_filter\_name | Name to use to find AMI images | `string` | `"ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"` | no |
| instance\_type | Instance type used for EC2 resources | `string` | `"t3.medium"` | no |
| internal\_domain\_name | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| internal\_zone\_name | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| prometheus\_1\_subnet | Name of the subnet to place the Prometheus instance and EBS volume | `string` | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| stackname | Stackname | `string` | n/a | yes |
| user\_data\_snippets | List of user-data snippets | `list` | n/a | yes |

## Outputs

No output.
