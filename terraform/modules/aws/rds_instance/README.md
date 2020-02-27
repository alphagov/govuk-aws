## Module: aws::rds\_instance

Create an RDS instance

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| allocated\_storage | The allocated storage in gigabytes. | `string` | `"10"` | no |
| backup\_retention\_period | The days to retain backups for. | `string` | `"7"` | no |
| backup\_window | The daily time range during which automated backups are created if automated backups are enabled. | `string` | `"01:00-03:00"` | no |
| copy\_tags\_to\_snapshot | Whether to copy the instance tags to the snapshot. | `string` | `"true"` | no |
| create\_rds\_notifications | Enable RDS events notifications | `string` | `true` | no |
| create\_replicate\_source\_db | Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate | `string` | `"0"` | no |
| default\_tags | Additional resource tags | `map` | `{}` | no |
| engine\_name | RDS engine (eg mysql, postgresql) | `string` | `""` | no |
| engine\_version | Which version of MySQL to use (eg 5.5.46) | `string` | `""` | no |
| event\_categories | A list of event categories for a SourceType that you want to subscribe to. See http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide//USER_Events.html | `list` | <pre>[<br>  "availability",<br>  "deletion",<br>  "failure",<br>  "low storage"<br>]</pre> | no |
| event\_sns\_topic\_arn | The SNS topic to send events to. | `string` | `""` | no |
| instance\_class | The instance type of the RDS instance. | `string` | `"db.t1.micro"` | no |
| instance\_name | The RDS Instance Name. | `string` | `""` | no |
| maintenance\_window | The window to perform maintenance in. | `string` | `"Mon:04:00-Mon:06:00"` | no |
| max\_allocated\_storage | current maximum storage in GB that AWS can autoscale the RDS storage to, 0 means disabled autoscaling | `string` | `"100"` | no |
| multi\_az | Specifies if the RDS instance is multi-AZ | `string` | `true` | no |
| name | The common name for all the resources created by this module | `string` | n/a | yes |
| parameter\_group\_name | Name of the parameter group to make the instance a member of. | `string` | `""` | no |
| password | Password for accessing the database. | `string` | `""` | no |
| replicate\_source\_db | Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate | `string` | `"false"` | no |
| security\_group\_ids | Security group IDs to apply to this cluster | `list` | n/a | yes |
| skip\_final\_snapshot | Set to true to NOT create a final snapshot when the cluster is deleted. | `string` | `"false"` | no |
| snapshot\_identifier | Specifies whether or not to create this database from a snapshot. | `string` | `""` | no |
| storage\_type | One of standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD). The default is gp2 | `string` | `"gp2"` | no |
| subnet\_ids | Subnet IDs to assign to the aws\_elasticache\_subnet\_group | `list` | `[]` | no |
| terraform\_create\_rds\_timeout | Set the timeout time for AWS RDS creation. | `string` | `"2h"` | no |
| terraform\_delete\_rds\_timeout | Set the timeout time for AWS RDS deletion. | `string` | `"2h"` | no |
| terraform\_update\_rds\_timeout | Set the timeout time for AWS RDS modification. | `string` | `"2h"` | no |
| username | User to create on the database | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| rds\_instance\_address | n/a |
| rds\_instance\_endpoint | n/a |
| rds\_instance\_id | n/a |
| rds\_instance\_resource\_id | n/a |
| rds\_replica\_address | n/a |
| rds\_replica\_endpoint | n/a |
| rds\_replica\_id | n/a |
| rds\_replica\_resource\_id | n/a |

