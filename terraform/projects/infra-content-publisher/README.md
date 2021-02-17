## Project: infra-content-publisher

Stores ActiveStorage blobs uploaded via Content Publisher.

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |
| aws | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 2.46.0 |
| aws.aws\_replica | 2.46.0 2.46.0 |
| template | n/a |
| terraform | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) |
| [aws_iam_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) |
| [aws_iam_user](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) |
| [aws_s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket_policy) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_integration\_account\_root\_arn | root arn of the aws integration account of govuk | `string` | `""` | no |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| aws\_replica\_region | AWS region | `string` | `"eu-west-2"` | no |
| aws\_staging\_account\_root\_arn | root arn of the aws staging account of govuk | `string` | `""` | no |
| aws\_test\_account\_root\_arn | root arn of the aws test account of govuk | `string` | `""` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| replication\_setting | Whether replication is Enabled or Disabled | `string` | `"Enabled"` | no |
| stackname | Stackname | `string` | n/a | yes |
| whole\_bucket\_lifecycle\_rule\_integration\_enabled | Set to true in Integration data to only apply these rules for Integration | `string` | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| integration\_content\_publisher\_active\_storage\_bucket\_reader\_writer\_policy\_arn | ARN of the staging content publisher storage bucket reader writer policy |
| production\_content\_publisher\_active\_storage\_bucket\_reader\_policy\_arn | ARN of the production content publisher storage bucket reader policy |
| staging\_content\_publisher\_active\_storage\_bucket\_reader\_policy\_arn | ARN of the staging content publisher storage bucket reader policy |
| staging\_content\_publisher\_active\_storage\_bucket\_reader\_writer\_policy\_arn | ARN of the staging content publisher storage bucket reader writer policy |
