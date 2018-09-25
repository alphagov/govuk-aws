{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:ListBucketVersions"
             ],
            "Resource": [
                "arn:aws:s3:::govuk-terraform-steppingstone-${aws_environment}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
             ],
            "Resource": [
                "arn:aws:s3:::govuk-terraform-steppingstone-${aws_environment}/*"
            ]
        }
    ]
 }
