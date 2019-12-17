## Project: infra-public-services

This project adds global resources for app components:
  - public facing LBs and DNS entries
  - internal DNS entries

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app\_stackname | Stackname of the app projects in this environment | string | `"blue"` | no |
| apt\_internal\_service\_names |  | list | `<list>` | no |
| apt\_public\_service\_cnames |  | list | `<list>` | no |
| apt\_public\_service\_names |  | list | `<list>` | no |
| asset\_master\_internal\_service\_names |  | list | `<list>` | no |
| aws\_environment | AWS Environment | string | n/a | yes |
| aws\_region | AWS region | string | `"eu-west-1"` | no |
| backend\_alb\_blocked\_host\_headers |  | list | `<list>` | no |
| backend\_internal\_service\_cnames |  | list | `<list>` | no |
| backend\_internal\_service\_names |  | list | `<list>` | no |
| backend\_public\_service\_cnames |  | list | `<list>` | no |
| backend\_public\_service\_names |  | list | `<list>` | no |
| backend\_redis\_internal\_service\_names |  | list | `<list>` | no |
| bouncer\_internal\_service\_names |  | list | `<list>` | no |
| bouncer\_public\_service\_names |  | list | `<list>` | no |
| cache\_internal\_service\_cnames |  | list | `<list>` | no |
| cache\_internal\_service\_names |  | list | `<list>` | no |
| cache\_public\_service\_cnames |  | list | `<list>` | no |
| cache\_public\_service\_names |  | list | `<list>` | no |
| calculators\_frontend\_internal\_service\_cnames |  | list | `<list>` | no |
| calculators\_frontend\_internal\_service\_names |  | list | `<list>` | no |
| calendars\_public\_service\_names |  | list | `<list>` | no |
| ckan\_internal\_service\_cnames |  | list | `<list>` | no |
| ckan\_internal\_service\_names |  | list | `<list>` | no |
| ckan\_public\_service\_cnames |  | list | `<list>` | no |
| ckan\_public\_service\_names |  | list | `<list>` | no |
| content\_data\_api\_db\_admin\_internal\_service\_names |  | list | `<list>` | no |
| content\_data\_api\_postgresql\_internal\_service\_names |  | list | `<list>` | no |
| content\_store\_internal\_service\_names |  | list | `<list>` | no |
| content\_store\_public\_service\_names |  | list | `<list>` | no |
| db\_admin\_internal\_service\_names |  | list | `<list>` | no |
| deploy\_internal\_service\_names |  | list | `<list>` | no |
| deploy\_public\_service\_names |  | list | `<list>` | no |
| docker\_management\_internal\_service\_names |  | list | `<list>` | no |
| draft\_cache\_internal\_service\_cnames |  | list | `<list>` | no |
| draft\_cache\_internal\_service\_names |  | list | `<list>` | no |
| draft\_cache\_public\_service\_cnames |  | list | `<list>` | no |
| draft\_cache\_public\_service\_names |  | list | `<list>` | no |
| draft\_content\_store\_internal\_service\_names |  | list | `<list>` | no |
| draft\_content\_store\_public\_service\_names |  | list | `<list>` | no |
| draft\_frontend\_internal\_service\_cnames |  | list | `<list>` | no |
| draft\_frontend\_internal\_service\_names |  | list | `<list>` | no |
| draft\_whitehall\_frontend\_internal\_service\_names |  | list | `<list>` | no |
| elasticsearch6\_internal\_service\_names |  | list | `<list>` | no |
| elb\_public\_certname | The ACM cert domain name to find the ARN of | string | n/a | yes |
| elb\_public\_secondary\_certname | The ACM secondary cert domain name to find the ARN of | string | n/a | yes |
| email\_alert\_api\_internal\_service\_names |  | list | `<list>` | no |
| email\_alert\_api\_public\_service\_names |  | list | `<list>` | no |
| enable\_lb\_app\_healthchecks | Use application specific target groups and healthchecks based on the list of services in the cname variable. | string | `"false"` | no |
| feedback\_public\_service\_names |  | list | `<list>` | no |
| frontend\_internal\_service\_cnames |  | list | `<list>` | no |
| frontend\_internal\_service\_names |  | list | `<list>` | no |
| graphite\_internal\_service\_names |  | list | `<list>` | no |
| graphite\_public\_service\_names |  | list | `<list>` | no |
| jumpbox\_public\_service\_names |  | list | `<list>` | no |
| licensify\_backend\_elb\_public\_certname | Domain name \(CN\) of the ACM cert to use for licensify\_backend. | string | n/a | yes |
| licensify\_backend\_public\_service\_names |  | list | `<list>` | no |
| licensify\_frontend\_internal\_service\_cnames |  | list | `<list>` | no |
| licensify\_frontend\_internal\_service\_names |  | list | `<list>` | no |
| licensify\_frontend\_public\_service\_cnames |  | list | `<list>` | no |
| licensify\_frontend\_public\_service\_names |  | list | `<list>` | no |
| mapit\_internal\_service\_names |  | list | `<list>` | no |
| mapit\_public\_service\_names |  | list | `<list>` | no |
| mongo\_internal\_service\_names |  | list | `<list>` | no |
| monitoring\_internal\_service\_names |  | list | `<list>` | no |
| monitoring\_internal\_service\_names\_cname\_dest | This variable specifies the CNAME record destination to be associated with the service names defined in monitoring\_internal\_service\_names | string | `"alert"` | no |
| monitoring\_public\_service\_names |  | list | `<list>` | no |
| mysql\_internal\_service\_names |  | list | `<list>` | no |
| postgresql\_internal\_service\_names |  | list | `<list>` | no |
| prometheus\_internal\_service\_names |  | list | `<list>` | no |
| prometheus\_public\_service\_names |  | list | `<list>` | no |
| publishing\_api\_internal\_service\_names |  | list | `<list>` | no |
| puppetmaster\_internal\_service\_names |  | list | `<list>` | no |
| rabbitmq\_internal\_service\_names |  | list | `<list>` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | string | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | string | `""` | no |
| remote\_state\_infra\_networking\_key\_stack | Override infra\_networking remote state path | string | `""` | no |
| remote\_state\_infra\_root\_dns\_zones\_key\_stack | Override stackname path to infra\_root\_dns\_zones remote state | string | `""` | no |
| remote\_state\_infra\_security\_groups\_key\_stack | Override infra\_security\_groups stackname path to infra\_vpc remote state | string | `""` | no |
| remote\_state\_infra\_stack\_dns\_zones\_key\_stack | Override stackname path to infra\_stack\_dns\_zones remote state | string | `""` | no |
| remote\_state\_infra\_vpc\_key\_stack | Override infra\_vpc remote state path | string | `""` | no |
| router\_backend\_internal\_service\_names |  | list | `<list>` | no |
| search\_api\_public\_service\_names |  | list | `<list>` | no |
| search\_internal\_service\_cnames |  | list | `<list>` | no |
| search\_internal\_service\_names |  | list | `<list>` | no |
| stackname | Stackname | string | n/a | yes |
| static\_public\_service\_names |  | list | `<list>` | no |
| support\_api\_public\_service\_names |  | list | `<list>` | no |
| transition\_db\_admin\_internal\_service\_names |  | list | `<list>` | no |
| transition\_postgresql\_internal\_service\_names |  | list | `<list>` | no |
| waf\_logs\_hec\_endpoint | Splunk endpoint for shipping application firewall logs | string | n/a | yes |
| waf\_logs\_hec\_token | Splunk token for shipping application firewall logs | string | n/a | yes |
| whitehall\_backend\_internal\_service\_cnames |  | list | `<list>` | no |
| whitehall\_backend\_internal\_service\_names |  | list | `<list>` | no |
| whitehall\_backend\_public\_service\_cnames |  | list | `<list>` | no |
| whitehall\_backend\_public\_service\_names |  | list | `<list>` | no |
| whitehall\_frontend\_internal\_service\_names |  | list | `<list>` | no |

