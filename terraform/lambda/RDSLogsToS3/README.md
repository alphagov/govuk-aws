## Send RDS logs to S3

This Lambda function retrieves RDS logs and stores them in the S3 logging bucket. It's
based on https://github.com/vcardillo/rdslogs_to_s3

It is triggered by an scheduled event.

### Requirements

Install [AWS sam-local](https://github.com/awslabs/aws-sam-local)

### Tests

Generate event JSON:

```
sam local generate-event schedule --region eu-west-1 > event.json
```

Configure the following environment variables in `template.yaml`:
 - RDS_INSTANCE_NAME: RDS test instance name
 - S3_BUCKET_NAME: logging bucket name
 - S3_BUCKET_PREFIX: rds/<rds_instance_name>/

Test the Lambda function:

```
sam local invoke RDSLogsToS3 -e event.json
```

