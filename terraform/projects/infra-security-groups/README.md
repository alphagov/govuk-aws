## Project: infra-security-groups

Manage the security groups for the entire infrastructure

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |
| fastly | 0.1.2 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| fastly | 0.1.2 |
| github | n/a |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_integration\_external\_nat\_gateway\_ips | An array of public IPs of the AWS integration external NAT gateways. | `list` | `[]` | no |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| aws\_staging\_external\_nat\_gateway\_ips | An array of public IPs of the AWS staging external NAT gateways. | `list` | `[]` | no |
| carrenza\_draft\_frontend\_ips | An array of CIDR blocks for the current environment that will allow access to draft-content-store from Carrenza. | `list` | `[]` | no |
| carrenza\_env\_ips | An array of CIDR blocks for the current environment that will be allowed to SSH to the jumpbox. | `list` | `[]` | no |
| carrenza\_integration\_ips | An array of CIDR blocks that will be allowed to SSH to the jumpbox. | `list` | n/a | yes |
| carrenza\_production\_ips | An array of CIDR blocks that will be allowed to SSH to the jumpbox. | `list` | n/a | yes |
| carrenza\_rabbitmq\_ips | An array of CIDR blocks that will be allowed to federate with the rabbitmq nodes. | `list` | <pre>[<br>  ""<br>]</pre> | no |
| carrenza\_staging\_ips | An array of CIDR blocks that will be allowed to SSH to the jumpbox. | `list` | n/a | yes |
| carrenza\_vpn\_subnet\_cidr | The Carrenza VPN subnet CIDR | `list` | `[]` | no |
| concourse\_aws\_account\_id | AWS account ID which contains the Concourse role | `string` | n/a | yes |
| concourse\_ips | An array of CIDR blocks that represent ingress Concourse | `list` | n/a | yes |
| ithc\_access\_ips | An array of CIDR blocks that will be allowed temporary access for ITHC purposes. | `list` | `[]` | no |
| office\_ips | An array of CIDR blocks that will be allowed offsite access. | `list` | n/a | yes |
| paas\_ireland\_egress\_ips | An array of CIDR blocks that are used for egress from the GOV.UK PaaS Ireland region | `list` | `[]` | no |
| paas\_london\_egress\_ips | An array of CIDR blocks that are used for egress from the GOV.UK PaaS London region | `list` | `[]` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | `string` | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | `string` | `""` | no |
| stackname | The name of the stack being built. Must be unique within the environment as it's used for disambiguation. | `string` | n/a | yes |
| traffic\_replay\_ips | An array of CIDR blocks that will replay traffic against an environment | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sg\_accessibility-reports\_id | n/a |
| sg\_apt\_external\_elb\_id | n/a |
| sg\_apt\_id | n/a |
| sg\_apt\_internal\_elb\_id | n/a |
| sg\_asset-master-efs\_id | n/a |
| sg\_asset-master\_id | n/a |
| sg\_aws-vpn\_id | n/a |
| sg\_backend-redis\_id | n/a |
| sg\_backend\_elb\_external\_id | n/a |
| sg\_backend\_elb\_internal\_id | n/a |
| sg\_backend\_id | n/a |
| sg\_bouncer\_elb\_id | n/a |
| sg\_bouncer\_id | n/a |
| sg\_bouncer\_internal\_elb\_id | n/a |
| sg\_cache\_elb\_id | n/a |
| sg\_cache\_external\_elb\_id | n/a |
| sg\_cache\_id | n/a |
| sg\_calculators-frontend\_elb\_id | n/a |
| sg\_calculators-frontend\_id | n/a |
| sg\_ci-agent-1\_elb\_id | n/a |
| sg\_ci-agent-1\_id | n/a |
| sg\_ci-agent-2\_elb\_id | n/a |
| sg\_ci-agent-2\_id | n/a |
| sg\_ci-agent-3\_elb\_id | n/a |
| sg\_ci-agent-3\_id | n/a |
| sg\_ci-agent-4\_elb\_id | n/a |
| sg\_ci-agent-4\_id | n/a |
| sg\_ci-agent-5\_elb\_id | n/a |
| sg\_ci-agent-5\_id | n/a |
| sg\_ci-agent-6\_elb\_id | n/a |
| sg\_ci-agent-6\_id | n/a |
| sg\_ci-agent-7\_elb\_id | n/a |
| sg\_ci-agent-7\_id | n/a |
| sg\_ci-agent-8\_elb\_id | n/a |
| sg\_ci-agent-8\_id | n/a |
| sg\_ci-master\_elb\_id | n/a |
| sg\_ci-master\_id | n/a |
| sg\_ci-master\_internal\_elb\_id | n/a |
| sg\_ckan\_elb\_external\_id | n/a |
| sg\_ckan\_elb\_internal\_id | n/a |
| sg\_ckan\_id | n/a |
| sg\_content-data-api-db-admin\_id | n/a |
| sg\_content-data-api-postgresql-primary\_id | n/a |
| sg\_content-store\_external\_elb\_id | n/a |
| sg\_content-store\_id | n/a |
| sg\_content-store\_internal\_elb\_id | n/a |
| sg\_data-science-data\_id | n/a |
| sg\_db-admin\_elb\_id | n/a |
| sg\_db-admin\_id | n/a |
| sg\_deploy\_elb\_id | n/a |
| sg\_deploy\_id | n/a |
| sg\_deploy\_internal\_elb\_id | n/a |
| sg\_docker\_management\_etcd\_elb\_id | n/a |
| sg\_docker\_management\_id | n/a |
| sg\_draft-cache\_elb\_id | n/a |
| sg\_draft-cache\_external\_elb\_id | n/a |
| sg\_draft-cache\_id | n/a |
| sg\_draft-content-store\_external\_elb\_id | n/a |
| sg\_draft-content-store\_id | n/a |
| sg\_draft-content-store\_internal\_elb\_id | n/a |
| sg\_draft-frontend\_elb\_id | n/a |
| sg\_draft-frontend\_id | n/a |
| sg\_elasticsearch6\_id | n/a |
| sg\_email-alert-api\_elb\_external\_id | n/a |
| sg\_email-alert-api\_elb\_internal\_id | n/a |
| sg\_email-alert-api\_id | n/a |
| sg\_feedback\_elb\_id | n/a |
| sg\_frontend\_cache\_id | n/a |
| sg\_frontend\_elb\_id | n/a |
| sg\_frontend\_id | n/a |
| sg\_gatling\_external\_elb\_id | n/a |
| sg\_gatling\_id | n/a |
| sg\_graphite\_external\_elb\_id | n/a |
| sg\_graphite\_id | n/a |
| sg\_graphite\_internal\_elb\_id | n/a |
| sg\_jumpbox\_id | n/a |
| sg\_knowledge-graph\_elb\_external\_id | n/a |
| sg\_knowledge-graph\_id | n/a |
| sg\_licensify-backend\_external\_elb\_id | n/a |
| sg\_licensify-backend\_id | n/a |
| sg\_licensify-backend\_internal\_elb\_id | n/a |
| sg\_licensify-frontend\_external\_elb\_id | n/a |
| sg\_licensify-frontend\_id | n/a |
| sg\_licensify-frontend\_internal\_lb\_id | n/a |
| sg\_licensify\_documentdb\_id | n/a |
| sg\_management\_id | n/a |
| sg\_mapit\_carrenza\_alb\_id | n/a |
| sg\_mapit\_elb\_id | n/a |
| sg\_mapit\_id | n/a |
| sg\_mirrorer\_id | n/a |
| sg\_mongo\_id | n/a |
| sg\_monitoring\_external\_elb\_id | n/a |
| sg\_monitoring\_id | n/a |
| sg\_monitoring\_internal\_elb\_id | n/a |
| sg\_mysql-primary\_id | n/a |
| sg\_mysql-replica\_id | n/a |
| sg\_offsite\_ssh\_id | n/a |
| sg\_postgresql-primary\_id | n/a |
| sg\_prometheus\_external\_elb\_id | n/a |
| sg\_prometheus\_id | n/a |
| sg\_publishing-api\_elb\_external\_id | n/a |
| sg\_publishing-api\_elb\_internal\_id | n/a |
| sg\_publishing-api\_id | n/a |
| sg\_puppetmaster\_elb\_id | n/a |
| sg\_puppetmaster\_id | n/a |
| sg\_rabbitmq\_elb\_id | n/a |
| sg\_rabbitmq\_id | n/a |
| sg\_related-links\_id | n/a |
| sg\_router-api\_elb\_id | n/a |
| sg\_router-backend\_id | n/a |
| sg\_search-api\_external\_elb\_id | n/a |
| sg\_search-ltr-generation\_id | n/a |
| sg\_search\_elb\_id | n/a |
| sg\_search\_id | n/a |
| sg\_shared\_documentdb\_id | n/a |
| sg\_static\_carrenza\_alb\_id | n/a |
| sg\_support-api\_external\_elb\_id | n/a |
| sg\_transition-db-admin\_elb\_id | n/a |
| sg\_transition-db-admin\_id | n/a |
| sg\_transition-postgresql-primary\_id | n/a |
| sg\_transition-postgresql-standby\_id | n/a |
| sg\_whitehall-backend\_external\_elb\_id | n/a |
| sg\_whitehall-backend\_id | n/a |
| sg\_whitehall-backend\_internal\_elb\_id | n/a |
| sg\_whitehall-frontend\_elb\_id | n/a |
| sg\_whitehall-frontend\_external\_elb\_id | n/a |
| sg\_whitehall-frontend\_id | n/a |

