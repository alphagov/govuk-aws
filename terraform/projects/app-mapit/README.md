## Project: app-mapit

Mapit node

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
| alarms-elb-mapit-internal | ../../modules/aws/alarms/elb |  |
| mapit-1 | ../../modules/aws/node_group |  |
| mapit-2 | ../../modules/aws/node_group |  |
| mapit-3 | ../../modules/aws/node_group |  |
| mapit-4 | ../../modules/aws/node_group |  |

## Resources

| Name |
|------|
| [aws_acm_certificate](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/acm_certificate) |
| [aws_ebs_volume](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/ebs_volume) |
| [aws_elasticache_cluster](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elasticache_cluster) |
| [aws_elasticache_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elasticache_subnet_group) |
| [aws_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| ebs\_device\_name | Name of the block device to mount on the instance, e.g. xvdf | `string` | n/a | yes |
| ebs\_device\_volume\_size | Size of additional ebs volume in GB | `string` | `"20"` | no |
| ebs\_encrypted | Whether or not the EBS volume is encrypted | `string` | n/a | yes |
| elb\_internal\_certname | The ACM cert domain name to find the ARN of | `string` | n/a | yes |
| instance\_ami\_filter\_name | Name to use to find AMI images | `string` | `""` | no |
| instance\_type | Instance type used for EC2 resources | `string` | `"c5.2xlarge"` | no |
| internal\_domain\_name | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| internal\_zone\_name | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
| lc\_create\_ebs\_volume | Creates a launch configuration which will add an additional ebs volume to the instance if this value is set to 1 | `string` | n/a | yes |
| mapit\_subnet\_a | Name of the subnet to place the first third of mapit instances and EBS volumes | `string` | n/a | yes |
| mapit\_subnet\_b | Name of the subnet to place the second third of mapit instances and EBS volumes | `string` | n/a | yes |
| mapit\_subnet\_c | Name of the subnet to place the last third of mapit instances and EBS volumes | `string` | n/a | yes |
| memcached\_instance\_type | Instance type used for the shared Elasticache Memcached instances | `string` | `"cache.m6g.large"` | no |
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

| Name | Description |
|------|-------------|
| mapit\_service\_dns\_name | DNS name to access the mapit internal service |
