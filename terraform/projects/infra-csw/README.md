## Module: projects/infra-csw

Role and policy for CSW

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.12.30 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_csw_inspector_role"></a> [csw\_inspector\_role](#module\_csw\_inspector\_role) | git::https://github.com/alphagov/csw-client-role.git | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_csw_agent_account_id"></a> [csw\_agent\_account\_id](#input\_csw\_agent\_account\_id) | n/a | `any` | n/a | yes |
| <a name="input_csw_prefix"></a> [csw\_prefix](#input\_csw\_prefix) | n/a | `string` | `"csw-prod"` | no |

## Outputs

No outputs.
