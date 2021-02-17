## Module: projects/infra-csw

Role and policy for CSW

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
| csw_inspector_role | git::https://github.com/alphagov/csw-client-role.git |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| csw\_agent\_account\_id | n/a | `any` | n/a | yes |
| csw\_prefix | n/a | `string` | `"csw-prod"` | no |

## Outputs

No output.
