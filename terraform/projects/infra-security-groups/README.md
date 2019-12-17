## Project: infra-security-groups

Manage the security groups for the entire infrastructure

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_environment | AWS Environment | string | n/a | yes |
| aws\_region | AWS region | string | `"eu-west-1"` | no |
| carrenza\_draft\_frontend\_ips | An array of CIDR blocks for the current environment that will allow access to draft-content-store from Carrenza. | list | `<list>` | no |
| carrenza\_env\_ips | An array of CIDR blocks for the current environment that will be allowed to SSH to the jumpbox. | list | `<list>` | no |
| carrenza\_integration\_ips | An array of CIDR blocks that will be allowed to SSH to the jumpbox. | list | n/a | yes |
| carrenza\_production\_ips | An array of CIDR blocks that will be allowed to SSH to the jumpbox. | list | n/a | yes |
| carrenza\_rabbitmq\_ips | An array of CIDR blocks that will be allowed to federate with the rabbitmq nodes. | list | `<list>` | no |
| carrenza\_staging\_ips | An array of CIDR blocks that will be allowed to SSH to the jumpbox. | list | n/a | yes |
| carrenza\_vpn\_subnet\_cidr | The Carrenza VPN subnet CIDR | list | `<list>` | no |
| concourse\_aws\_account\_id | AWS account ID which contains the Concourse role | string | n/a | yes |
| concourse\_ips | An array of CIDR blocks that represent ingress Concourse | list | n/a | yes |
| ithc\_access\_ips | An array of CIDR blocks that will be allowed temporary access for ITHC purposes. | list | `<list>` | no |
| office\_ips | An array of CIDR blocks that will be allowed offsite access. | list | n/a | yes |
| remote\_state\_bucket | S3 bucket we store our terraform state in | string | n/a | yes |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | string | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | string | `""` | no |
| stackname | The name of the stack being built. Must be unique within the environment as it's used for disambiguation. | string | n/a | yes |
| traffic\_replay\_ips | An array of CIDR blocks that will replay traffic against an environment | list | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sg\_apt\_external\_elb\_id |  |
| sg\_apt\_id |  |
| sg\_apt\_internal\_elb\_id |  |
| sg\_asset-master-efs\_id |  |
| sg\_asset-master\_id |  |
| sg\_aws-vpn\_id |  |
| sg\_backend-redis\_id |  |
| sg\_backend\_elb\_external\_id |  |
| sg\_backend\_elb\_internal\_id |  |
| sg\_backend\_id |  |
| sg\_bouncer\_elb\_id |  |
| sg\_bouncer\_id |  |
| sg\_bouncer\_internal\_elb\_id |  |
| sg\_cache\_elb\_id |  |
| sg\_cache\_external\_elb\_id |  |
| sg\_cache\_id |  |
| sg\_calculators-frontend\_elb\_id |  |
| sg\_calculators-frontend\_id |  |
| sg\_calendars\_carrenza\_alb\_id |  |
| sg\_ckan\_elb\_external\_id |  |
| sg\_ckan\_elb\_internal\_id |  |
| sg\_ckan\_id |  |
| sg\_content-data-api-db-admin\_id |  |
| sg\_content-data-api-postgresql-primary\_id |  |
| sg\_content-store\_external\_elb\_id |  |
| sg\_content-store\_id |  |
| sg\_content-store\_internal\_elb\_id |  |
| sg\_db-admin\_elb\_id |  |
| sg\_db-admin\_id |  |
| sg\_deploy\_elb\_id |  |
| sg\_deploy\_id |  |
| sg\_deploy\_internal\_elb\_id |  |
| sg\_docker\_management\_etcd\_elb\_id |  |
| sg\_docker\_management\_id |  |
| sg\_draft-cache\_elb\_id |  |
| sg\_draft-cache\_external\_elb\_id |  |
| sg\_draft-cache\_id |  |
| sg\_draft-content-store\_external\_elb\_id |  |
| sg\_draft-content-store\_id |  |
| sg\_draft-content-store\_internal\_elb\_id |  |
| sg\_draft-frontend\_elb\_id |  |
| sg\_draft-frontend\_id |  |
| sg\_elasticsearch6\_id |  |
| sg\_email-alert-api\_elb\_external\_id |  |
| sg\_email-alert-api\_elb\_internal\_id |  |
| sg\_email-alert-api\_id |  |
| sg\_feedback\_elb\_id |  |
| sg\_frontend\_elb\_id |  |
| sg\_frontend\_id |  |
| sg\_gatling\_external\_elb\_id |  |
| sg\_gatling\_id |  |
| sg\_graphite\_external\_elb\_id |  |
| sg\_graphite\_id |  |
| sg\_graphite\_internal\_elb\_id |  |
| sg\_jumpbox\_id |  |
| sg\_knowledge-graph\_elb\_external\_id |  |
| sg\_knowledge-graph\_id |  |
| sg\_licensify-backend\_external\_elb\_id |  |
| sg\_licensify-backend\_id |  |
| sg\_licensify-backend\_internal\_elb\_id |  |
| sg\_licensify-frontend\_external\_elb\_id |  |
| sg\_licensify-frontend\_id |  |
| sg\_licensify-frontend\_internal\_lb\_id |  |
| sg\_licensify\_documentdb\_id |  |
| sg\_management\_id |  |
| sg\_mapit\_carrenza\_alb\_id |  |
| sg\_mapit\_elb\_id |  |
| sg\_mapit\_id |  |
| sg\_mirrorer\_id |  |
| sg\_mongo\_id |  |
| sg\_monitoring\_external\_elb\_id |  |
| sg\_monitoring\_id |  |
| sg\_monitoring\_internal\_elb\_id |  |
| sg\_mysql-primary\_id |  |
| sg\_mysql-replica\_id |  |
| sg\_offsite\_ssh\_id |  |
| sg\_postgresql-primary\_id |  |
| sg\_prometheus\_external\_elb\_id |  |
| sg\_prometheus\_id |  |
| sg\_publishing-api\_elb\_external\_id |  |
| sg\_publishing-api\_elb\_internal\_id |  |
| sg\_publishing-api\_id |  |
| sg\_puppetmaster\_elb\_id |  |
| sg\_puppetmaster\_id |  |
| sg\_rabbitmq\_elb\_id |  |
| sg\_rabbitmq\_id |  |
| sg\_related-links\_id |  |
| sg\_router-api\_elb\_id |  |
| sg\_router-backend\_id |  |
| sg\_search-api\_external\_elb\_id |  |
| sg\_search\_elb\_id |  |
| sg\_search\_id |  |
| sg\_shared\_documentdb\_id |  |
| sg\_static\_carrenza\_alb\_id |  |
| sg\_support-api\_external\_elb\_id |  |
| sg\_transition-db-admin\_elb\_id |  |
| sg\_transition-db-admin\_id |  |
| sg\_transition-postgresql-primary\_id |  |
| sg\_transition-postgresql-standby\_id |  |
| sg\_whitehall-backend\_external\_elb\_id |  |
| sg\_whitehall-backend\_id |  |
| sg\_whitehall-backend\_internal\_elb\_id |  |
| sg\_whitehall-frontend\_elb\_id |  |
| sg\_whitehall-frontend\_id |  |

