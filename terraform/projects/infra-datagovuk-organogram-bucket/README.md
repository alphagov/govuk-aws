## Project: app-asset-master

Assets EFS (NFS) volume.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |
| <a name="provider_fastly"></a> [fastly](#provider\_fastly) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.assets-efs-fs](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.assets-mount-target](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/efs_mount_target) | resource |
| [aws_iam_policy.s3_datagovuk_organogram_writer_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.s3_datagovuk_organogram_writer_user_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_user.s3_datagovuk_organogram_writer_user](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_user) | resource |
| [aws_route53_record.assets_service_record](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_iam_policy_document.s3_datagovuk_organogram_writer_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_fastly_read_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/route53_zone) | data source |
| [fastly_ip_ranges.fastly](https://registry.terraform.io/providers/hashicorp/fastly/latest/docs/data-sources/ip_ranges) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain of the data.gov.uk service to manage | `string` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |

## Outputs

No outputs.
