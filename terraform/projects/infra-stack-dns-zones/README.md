## Project: infra-stack-dns-zones

This module creates the internal and external DNS zones used by our stacks.

When we select to create a DNS zone, the domain name and ID of the zone that  
manages the root domain needs to be provided to register the DNS delegation  
and NS servers of the created zone. The domain name of the new zone is created  
from the variables provided as <stackname>.<root\_domain\_internal\|external\_name>

We can't create a internal DNS zone per stack because on AWS we can't overlap  
internal domain names. Instead we use the same internal zone for all the sacks  
and we use the name schema `<service>.<stackname>.<root_domain>`

The outputs of this project should be used by the stacks to create the right  
service records on the internal and external DNS zones.

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| create\_external\_zone | Create an external DNS zone (default true) | `string` | `true` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| root\_domain\_external\_name | External DNS root domain name. Override default for Integration, Staging, Production if create\_external\_zone is true | `string` | `"mydomain.external"` | no |
| root\_domain\_internal\_name | Internal DNS root domain name. Override default for Integration, Staging, Production if create\_internal\_zone is true | `string` | `"mydomain.internal"` | no |
| stackname | Stackname | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| external\_domain\_name | Route53 External Domain Name |
| external\_zone\_id | Route53 External Zone ID |
| internal\_domain\_name | Route53 Internal Domain Name |
| internal\_zone\_id | Route53 Internal Zone ID |

