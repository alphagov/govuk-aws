## Module: projects/infra-vpc

Creates the base VPC layer for an AWS stack, with VPC flow logs  
and resources to export these logs to S3

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| terraform | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| vpc | ../../modules/aws/network/vpc |  |
| vpc_flow_log_exporter | ../../modules/aws/cloudwatch_log_exporter |  |

## Resources

| Name |
|------|
| [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/cloudwatch_log_group) |
| [aws_flow_log](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/flow_log) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy_attachment) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| cloudwatch\_log\_retention | Number of days to retain Cloudwatch logs for | `string` | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| stackname | Stackname | `string` | `""` | no |
| traffic\_type | The traffic type to capture. Allows ACCEPT, ALL or REJECT | `string` | `"REJECT"` | no |
| vpc\_cidr | VPC IP address range, represented as a CIDR block | `string` | n/a | yes |
| vpc\_name | A name tag for the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| internet\_gateway\_id | The ID of the Internet Gateway |
| route\_table\_public\_id | The ID of the public routing table |
| vpc\_cidr | The CIDR block of the VPC |
| vpc\_id | The ID of the VPC |
