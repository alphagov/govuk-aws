## Module: projects/infra-cyber-security-audit

Role and policy for Cyber security audit, to eventually deprecate the CSW-specific role

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |

## Providers

No provider.

## Modules

| Name | Source | Version |
|------|--------|---------|
| cyber_security_audit_role | git::https://github.com/alphagov/tech-ops.git?ref=13f54e5//cyber-security/modules/gds_security_audit_role |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | n/a | `string` | `"eu-west-1"` | no |
| chain\_account\_id | n/a | `string` | `"988997429095"` | no |

## Outputs

No output.
