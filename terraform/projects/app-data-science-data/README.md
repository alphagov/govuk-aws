## Project: app-data-science-data

Data science data

A central place where data is generated on a daily basis to be used by multiple data science projects, including related links and the knowledge graph.

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 1.40.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 1.40.0 |
| template | n/a |
| terraform | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_ami](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/ami) |
| [aws_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/autoscaling_group) |
| [aws_autoscaling_schedule](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/autoscaling_schedule) |
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/caller_identity) |
| [aws_iam_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_instance_profile) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/iam_role_policy_attachment) |
| [aws_launch_template](https://registry.terraform.io/providers/hashicorp/aws/1.40.0/docs/resources/launch_template) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| remote\_state\_app\_knowledge\_graph\_key\_stack | Override app\_knowledge\_graph remote state path | `string` | `""` | no |
| remote\_state\_app\_related\_links\_key\_stack | Override stackname path to app\_related\_links remote state | `string` | `""` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_database\_backups\_bucket\_key\_stack | Override stackname path to infra\_database\_backups\_bucket remote state | `string` | `""` | no |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| stackname | Stackname | `string` | n/a | yes |

## Outputs

No output.
