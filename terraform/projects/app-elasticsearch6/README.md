## Project: app-elasticsearch6

Managed Elasticsearch 6 cluster

This project has two gotchas, where we work around things terraform  
doesn't support:

- Deploying the cluster across 3 availability zones: terraform has  
  some built-in validation which rejects using 3 master nodes and 3  
  data nodes across 3 availability zones.  To provision a new  
  cluster, only use two of everything, then bump the numbers in the  
  AWS console and in the terraform variables - it won't complain  
  when you next plan.

  https://github.com/terraform-providers/terraform-provider-aws/issues/7504

- Configuring a snapshot repository: terraform doesn't support this,  
  and as far as I can tell doesn't have any plans to.  There's a  
  Python script in this directory which sets those up.

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| cloudwatch\_log\_retention | Number of days to retain Cloudwatch logs for | `string` | `90` | no |
| elasticsearch6\_dedicated\_master\_enabled | Indicates whether dedicated master nodes are enabled for the cluster | `string` | `"true"` | no |
| elasticsearch6\_ebs\_encrypt | Whether to encrypt the EBS volume at rest | `string` | n/a | yes |
| elasticsearch6\_ebs\_size | The amount of EBS storage to attach | `string` | `32` | no |
| elasticsearch6\_ebs\_type | The type of EBS storage to attach | `string` | `"gp2"` | no |
| elasticsearch6\_instance\_count | The number of ElasticSearch nodes | `string` | `"6"` | no |
| elasticsearch6\_instance\_type | The instance type of the individual ElasticSearch nodes, only instances which allow EBS volumes are supported | `string` | `"r4.xlarge.elasticsearch"` | no |
| elasticsearch6\_manual\_snapshot\_bucket\_arns | Bucket ARNs this domain can read/write for manual snapshots | `list` | `[]` | no |
| elasticsearch6\_master\_instance\_count | Number of dedicated master nodes in the cluster | `string` | `"2"` | no |
| elasticsearch6\_master\_instance\_type | Instance type of the dedicated master nodes in the cluster | `string` | `"c4.large.elasticsearch"` | no |
| elasticsearch6\_snapshot\_start\_hour | The hour in which the daily snapshot is taken | `string` | `1` | no |
| elasticsearch\_subnet\_names | Names of the subnets to place the ElasticSearch domain in | `list` | n/a | yes |
| internal\_domain\_name | The domain name of the internal DNS records, it could be different from the zone name | `string` | n/a | yes |
| internal\_zone\_name | The name of the Route53 zone that contains internal records | `string` | n/a | yes |
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
| domain\_configuration\_policy\_arn | ARN of the policy used to configure the elasticsearch domain |
| manual\_snapshots\_bucket\_arn | ARN of the bucket to store manual snapshots |
| service\_dns\_name | DNS name to access the Elasticsearch internal service |
| service\_endpoint | Endpoint to submit index, search, and upload requests |

