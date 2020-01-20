## Module: govuk-repo-mirror

Configures a user and role to allow the govuk-repo-mirror Concourse pipeline  
to push to AWS CodeCommit (the user is used by the Jenkins  
Deploy\_App job and the role is used by the Concourse mirroring job)

## Providers

| Name | Version |
|------|---------|
| aws | 2.33.0 |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| concourse\_role\_arn | The role ARN of the role that Concourse uses to assume the govuk\_concourse\_codecommit\_role role | `string` | n/a | yes |
| jenkins\_carrenza\_production\_ssh\_public\_key | The SSH public key of the Jenkins instance in the Carrenza production environment | `string` | n/a | yes |
| jenkins\_carrenza\_staging\_ssh\_public\_key | The SSH public key of the Jenkins instance in the Carrenza staging environment | `string` | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| stackname | Stackname | `string` | n/a | yes |

## Outputs

No output.

