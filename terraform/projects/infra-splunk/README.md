## Module: projects/infra-splunk

Role and policy for Splunk Discovery delegated by the Cyber Security Team

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.splunk_aws_ro_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.splunk_aws_ro_policy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |

## Outputs

No outputs.
