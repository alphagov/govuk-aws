## Module: govuk-csp-forwarder

Configures a role and Lambda function to collect Content Security Policy  
reports, filter them and forward them to Sentry.

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| terraform | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_api_gateway_deployment](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/api_gateway_deployment) |
| [aws_api_gateway_integration](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/api_gateway_integration) |
| [aws_api_gateway_method](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/api_gateway_method) |
| [aws_api_gateway_resource](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/api_gateway_resource) |
| [aws_api_gateway_rest_api](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/api_gateway_rest_api) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) |
| [aws_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lambda_function) |
| [aws_lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lambda_permission) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | AWS region | `string` | `"eu-west-2"` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| stackname | Stackname | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| govuk\_csp\_forwarder\_report\_url | n/a |
