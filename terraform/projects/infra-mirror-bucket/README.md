## Project: infra-mirror-bucket

This project creates two s3 buckets: a primary s3 bucket to store the govuk
mirror files and a replica s3 bucket which tracks the primary s3 bucket.

The primary bucket should be in London and the backup in Ireland.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.13.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.76 |
| <a name="requirement_fastly"></a> [fastly](#requirement\_fastly) | >= 3.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.76 |
| <a name="provider_aws.aws_replica"></a> [aws.aws\_replica](#provider\_aws.aws\_replica) | ~> 3.76 |
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_fastly"></a> [fastly](#provider\_fastly) | >= 3.0.4 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.govuk_mirror_read_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.govuk_mirror_replication_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.govuk_mirror_read_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.govuk_mirror_replication_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.govuk_mirror_replication_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_user.govuk_mirror_google_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_s3_bucket.govuk-mirror](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.govuk-mirror-replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.govuk_mirror_read_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.govuk_mirror_replica_read_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.s3_mirror_read_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_mirror_replica_read_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [external_external.pingdom](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [fastly_ip_ranges.fastly](https://registry.terraform.io/providers/fastly/fastly/latest/docs/data-sources/ip_ranges) | data source |
| [template_file.s3_govuk_mirror_read_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_govuk_mirror_replication_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.s3_govuk_mirror_replication_role_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_integration_account_root_arn"></a> [aws\_integration\_account\_root\_arn](#input\_aws\_integration\_account\_root\_arn) | AWS account root ARN for the Integration account | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region where primary s3 bucket is located | `string` | `"eu-west-2"` | no |
| <a name="input_aws_replica_region"></a> [aws\_replica\_region](#input\_aws\_replica\_region) | AWS region where replica s3 bucket is located | `string` | `"eu-west-1"` | no |
| <a name="input_eks_egress_ips"></a> [eks\_egress\_ips](#input\_eks\_egress\_ips) | Egress addresses for the corresponding EKS environment, in CIDR notation. | `list(string)` | n/a | yes |
| <a name="input_enable_replica_lifecycle_rules"></a> [enable\_replica\_lifecycle\_rules](#input\_enable\_replica\_lifecycle\_rules) | Enable lifecycle rules for the mirror bucket's replica | `bool` | `true` | no |
| <a name="input_enable_replication"></a> [enable\_replication](#input\_enable\_replication) | Enable replication from the mirror bucket to its replica | `bool` | `true` | no |
| <a name="input_gds_egress_ips"></a> [gds\_egress\_ips](#input\_gds\_egress\_ips) | An array of CIDR blocks that will be allowed offsite access. | `list(any)` | n/a | yes |
| <a name="input_lifecycle_government_uploads"></a> [lifecycle\_government\_uploads](#input\_lifecycle\_government\_uploads) | Number of days for the lifecycle rule for the mirror in the case where the prefix path is www.gov.uk/government/uploads/ | `string` | `"8"` | no |
| <a name="input_lifecycle_main"></a> [lifecycle\_main](#input\_lifecycle\_main) | Number of days for the lifecycle rule for the mirror | `string` | `"5"` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |

## Outputs

No outputs.
