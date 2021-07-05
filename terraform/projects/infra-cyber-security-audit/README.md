## Module: projects/infra-cyber-security-audit

Role and policy for Cyber security audit, to eventually deprecate the CSW-specific role

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cyber_security_audit_role"></a> [cyber\_security\_audit\_role](#module\_cyber\_security\_audit\_role) | git::https://github.com/alphagov/tech-ops.git | 13f54e5//cyber-security/modules/gds_security_audit_role |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"eu-west-1"` | no |
| <a name="input_chain_account_id"></a> [chain\_account\_id](#input\_chain\_account\_id) | n/a | `string` | `"988997429095"` | no |

## Outputs

No outputs.
