## Module: govuk-csp-forwarder

Configures a role and Lambda function to collect Content Security Policy
reports, filter them and forward them to Sentry.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_deployment.govuk_csp_forwarder_api_gateway_deployment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.lambda](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.lambda_root](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_method.proxy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.proxy_root](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_resource.proxy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.govuk_csp_forwarder_api_gateway](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/api_gateway_rest_api) | resource |
| [aws_iam_role.govuk_csp_forwarder_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_lambda_function.govuk_csp_forwarder_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.govuk_csp_forwarder_api_gateway_invoke_permission](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lambda_permission) | resource |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_stack_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-2"` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_govuk_csp_forwarder_report_url"></a> [govuk\_csp\_forwarder\_report\_url](#output\_govuk\_csp\_forwarder\_report\_url) | n/a |
