## Project: database-backups-bucket

This creates an s3 bucket

database-backups: The bucket that will hold database backups

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.11.14 |
| aws | 2.46.0 |
| aws | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 2.46.0 2.46.0 |
| aws.eu-london | 2.46.0 2.46.0 |
| template | n/a |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_backup\_region | AWS region | `string` | `"eu-west-2"` | no |
| aws\_environment | AWS Environment | `string` | n/a | yes |
| aws\_region | AWS region | `string` | `"eu-west-1"` | no |
| expiration\_time | Expiration time in days of S3 Objects | `string` | `"120"` | no |
| expiration\_time\_whisper\_mongo | Expiration time in days for Whisper/Mongo S3 database backups | `string` | `"7"` | no |
| glacier\_storage\_time | Storage time in days for Glacier Objects | `string` | `"90"` | no |
| integration\_only | Only apply these policies to integration | `string` | `"false"` | no |
| remote\_state\_bucket | S3 bucket we store our terraform state in | `string` | n/a | yes |
| remote\_state\_infra\_monitoring\_key\_stack | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| replication\_setting | Whether replication is Enabled or Disabled | `string` | `"Enabled"` | no |
| stackname | Stackname | `string` | n/a | yes |
| standard\_s3\_storage\_time | Storage time in days for Standard S3 Bucket Objects | `string` | `"30"` | no |

## Outputs

| Name | Description |
|------|-------------|
| content\_data\_api\_dbadmin\_write\_database\_backups\_bucket\_policy\_arn | ARN of the Content Data API DBAdmin database\_backups bucket writer policy |
| dbadmin\_write\_database\_backups\_bucket\_policy\_arn | ARN of the DBAdmin write database\_backups-bucket policy |
| elasticsearch\_write\_database\_backups\_bucket\_policy\_arn | ARN of the elasticsearch write database\_backups-bucket policy |
| email-alert-api\_dbadmin\_write\_database\_backups\_bucket\_policy\_arn | ARN of the EmailAlertAPIDBAdmin write database\_backups-bucket policy |
| graphite\_write\_database\_backups\_bucket\_policy\_arn | ARN of the Graphite write database\_backups-bucket policy |
| integration\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the integration read DBAdmin database\_backups-bucket policy |
| integration\_elasticsearch\_read\_database\_backups\_bucket\_policy\_arn | ARN of the integration read elasticsearch database\_backups-bucket policy |
| integration\_email-alert-api\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the integration read EmailAlertAPUDBAdmin database\_backups-bucket policy |
| integration\_graphite\_read\_database\_backups\_bucket\_policy\_arn | ARN of the integration read Graphite database\_backups-bucket policy |
| integration\_mongo\_api\_read\_database\_backups\_bucket\_policy\_arn | ARN of the integration read mongo-api database\_backups-bucket policy |
| integration\_mongo\_router\_read\_database\_backups\_bucket\_policy\_arn | ARN of the integration read router\_backend database\_backups-bucket policy |
| integration\_mongodb\_read\_database\_backups\_bucket\_policy\_arn | ARN of the integration read mongodb database\_backups-bucket policy |
| integration\_publishing-api\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the integration read publishing-apiDBAdmin database\_backups-bucket policy |
| integration\_transition\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the integration read TransitionDBAdmin database\_backups-bucket policy |
| mongo\_api\_write\_database\_backups\_bucket\_policy\_arn | ARN of the mongo-api write database\_backups-bucket policy |
| mongo\_router\_write\_database\_backups\_bucket\_policy\_arn | ARN of the router\_backend write database\_backups-bucket policy |
| mongodb\_write\_database\_backups\_bucket\_policy\_arn | ARN of the mongodb write database\_backups-bucket policy |
| production\_content\_data\_api\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the production database\_backups bucket reader policy for the Content Data API |
| production\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the production read DBAdmin database\_backups-bucket policy |
| production\_elasticsearch\_read\_database\_backups\_bucket\_policy\_arn | ARN of the production read elasticsearch database\_backups-bucket policy |
| production\_email-alert-api\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the production read EmailAlertAPUDBAdmin database\_backups-bucket policy |
| production\_graphite\_read\_database\_backups\_bucket\_policy\_arn | ARN of the production read Graphite database\_backups-bucket policy |
| production\_mongo\_api\_read\_database\_backups\_bucket\_policy\_arn | ARN of the production read mongo-api database\_backups-bucket policy |
| production\_mongo\_router\_read\_database\_backups\_bucket\_policy\_arn | ARN of the production read router\_backend database\_backups-bucket policy |
| production\_mongodb\_read\_database\_backups\_bucket\_policy\_arn | ARN of the production read mongodb database\_backups-bucket policy |
| production\_publishing-api\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the production read publishing-apiDBAdmin database\_backups-bucket policy |
| production\_transition\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the production read TransitionDBAdmin database\_backups-bucket policy |
| publishing-api\_dbadmin\_write\_database\_backups\_bucket\_policy\_arn | ARN of the publishing-apiDBAdmin write database\_backups-bucket policy |
| s3\_database\_backups\_bucket\_name | The name of the database backups bucket |
| staging\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the staging read DBAdmin database\_backups-bucket policy |
| staging\_elasticsearch\_read\_database\_backups\_bucket\_policy\_arn | ARN of the staging read elasticsearch database\_backups-bucket policy |
| staging\_email-alert-api\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the staging read EmailAlertAPUDBAdmin database\_backups-bucket policy |
| staging\_graphite\_read\_database\_backups\_bucket\_policy\_arn | ARN of the staging read Graphite database\_backups-bucket policy |
| staging\_mongo\_api\_read\_database\_backups\_bucket\_policy\_arn | ARN of the staging read mongo-api database\_backups-bucket policy |
| staging\_mongo\_router\_read\_database\_backups\_bucket\_policy\_arn | ARN of the staging read router\_backend database\_backups-bucket policy |
| staging\_mongodb\_read\_database\_backups\_bucket\_policy\_arn | ARN of the staging read mongodb database\_backups-bucket policy |
| staging\_publishing-api\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the staging read publishing-apiDBAdmin database\_backups-bucket policy |
| staging\_transition\_dbadmin\_read\_database\_backups\_bucket\_policy\_arn | ARN of the staging read TransitionDBAdmin database\_backups-bucket policy |
| transition\_dbadmin\_write\_database\_backups\_bucket\_policy\_arn | ARN of the TransitionDBAdmin write database\_backups-bucket policy |

