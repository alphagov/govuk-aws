{
    "Version": "2018-02-01",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
             ],
            "Resource": [
                "arn:aws:s3:::govuk-integration-database-backups"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListObjects"
             ],
            "Resource": [
                "arn:aws:s3:::govuk-integration-database-backups/*"
            ]
        }
    ]
 }
