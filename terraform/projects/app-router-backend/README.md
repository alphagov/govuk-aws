## Project: app-router-backend

Router backend hosts both Mongo and router-api

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
| alarms-elb-router-api-internal | ../../modules/aws/alarms/elb |  |
| router-backend-1 | ../../modules/aws/node_group |  |
| router-backend-2 | ../../modules/aws/node_group |  |
| router-backend-3 | ../../modules/aws/node_group |  |

## Resources

| Name |
|------|
| [aws_acm_certificate](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/acm_certificate) |
| [aws_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) |
| [aws_network_interface](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/network_interface) |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| elb\_internal\_certname | The ACM cert domain name to find the ARN of | `string` | n/a | yes |
| instance\_ami\_filter\_name | Name to use to find AMI images | `string` | `""` | no |
| instance\_type | Instance type used for EC2 resources | `string` | `"t2.medium"` | no |
| internal\_domain\_name | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| internal\_zone\_name | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_database\_backups\_bucket\_key\_stack | Override stackname path to infra\_database\_backups\_bucket remote state | `string` | `""` | no |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| router-backend\_1\_ip | IP address of the private IP to assign to the instance | `string` | n/a | yes |
| router-backend\_1\_reserved\_ips\_subnet | Name of the subnet to place the reserved IP of the instance | `string` | n/a | yes |
| router-backend\_1\_subnet | Name of the subnet to place the Router Mongo 1 | `string` | n/a | yes |
| router-backend\_2\_ip | IP address of the private IP to assign to the instance | `string` | n/a | yes |
| router-backend\_2\_reserved\_ips\_subnet | Name of the subnet to place the reserved IP of the instance | `string` | n/a | yes |
| router-backend\_2\_subnet | Name of the subnet to place the Router Mongo 2 | `string` | n/a | yes |
| router-backend\_3\_ip | IP address of the private IP to assign to the instance | `string` | n/a | yes |
| router-backend\_3\_reserved\_ips\_subnet | Name of the subnet to place the reserved IP of the instance | `string` | n/a | yes |
| router-backend\_3\_subnet | Name of the subnet to place the Router Mongo 3 | `string` | n/a | yes |
| stackname | Stackname | `string` | n/a | yes |
| user\_data\_snippets | List of user-data snippets | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| router\_api\_service\_dns\_name | DNS name to access the router-api internal service |
| router\_backend\_1\_service\_dns\_name | DNS name to access the Router Mongo 1 internal service |
| router\_backend\_2\_service\_dns\_name | DNS name to access the Router Mongo 2 internal service |
| router\_backend\_3\_service\_dns\_name | DNS name to access the Router Mongo 3 internal service |
