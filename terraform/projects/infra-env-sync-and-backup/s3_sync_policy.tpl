{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
             ],
            "Resource": [
                "arn:aws:s3:::govuk-production-${bucket_suffix}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
             ],
            "Resource": [
                "arn:aws:s3:::govuk-production-${bucket_suffix}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
             ],
            "Resource": [
                "arn:aws:s3:::govuk-integration-${bucket_suffix}",
                "arn:aws:s3:::govuk-staging-${bucket_suffix}",
                "arn:aws:s3:::govuk-test-${bucket_suffix}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::govuk-integration-${bucket_suffix}/*",
                "arn:aws:s3:::govuk-staging-${bucket_suffix}/*",
                "arn:aws:s3:::govuk-test-${bucket_suffix}/*"
            ]
        }
    ]
}
