## Project: app-licensify-documentdb

DocumentDB cluster for Licensify


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_environment | AWS environment | string | - | yes |
| aws_region | AWS region | string | `eu-west-1` | no |
| instance_count | Instance count used for Licensify DocumentDB resources | string | `3` | no |
| instance_type | Instance type used for Licensify DocumentDB resources | string | `db.r5.large` | no |
| master_password | Password of master user on Licensify DocumentDB cluster | string | - | yes |
| master_username | Username of master user on Licensify DocumentDB cluster | string | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_security_groups_key_stack | Override infra_security_groups stackname path to infra_vpc remote state | string | `` | no |
| remote_state_infra_security_key_stack | Override infra_security stackname path to infra_vpc remote state | string | `` | no |
| stackname | Stackname | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| licensify_documentdb_endpoint | Outputs -------------------------------------------------------------- |

