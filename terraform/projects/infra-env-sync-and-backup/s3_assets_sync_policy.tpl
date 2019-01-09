{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::govuk-assets-production"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::govuk-assets-production/*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": [
                "arn:aws:s3:::govuk-assets-staging",
                "arn:aws:s3:::govuk-assets-integration"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "s3:PutObjectAcl",
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::govuk-assets-staging/*",
                "arn:aws:s3:::govuk-assets-integration/*"
            ]
        }
    ]
}
