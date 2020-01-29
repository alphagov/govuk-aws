## Module: projects/infra-security

Infrastructure security settings:  
 - Create admin role for trusted users from GDS proxy account  
 - Create users role for trusted users from GDS proxy account  
 - Default IAM password policy  
 - Default SSH key  
 - SOPS KMS key

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| role\_admin\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_admin\_user\_arns | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| role\_datascienceuser\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_datascienceuser\_user\_arns | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| role\_internal\_admin\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_internal\_admin\_user\_arns | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| role\_platformhealth\_poweruser\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_platformhealth\_poweruser\_user\_arns | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| role\_poweruser\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_poweruser\_user\_arns | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| role\_user\_policy\_arns | List of ARNs of policies to attach to the role | `list` | `[]` | no |
| role\_user\_user\_arns | List of ARNs of external users that can assume the role | `list` | `[]` | no |
| ssh\_public\_key | The public part of an SSH keypair | `string` | n/a | yes |
| stackname | Stackname | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| licensify\_documentdb\_kms\_key\_arn | The ARN of the Licensify DocumentDB KMS key |
| shared\_documentdb\_kms\_key\_arn | The ARN of the Shared DocumentDB KMS key |
| sops\_kms\_key\_arn | The ARN of the Sops KMS key |

