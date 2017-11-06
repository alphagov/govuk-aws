{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
             ],
            "Resource": [
                "arn:aws:s3:::govuk-${aws_environment}-aws-logging"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListObjects"
             ],
            "Resource": [
                "arn:aws:s3:::govuk-${aws_environment}-aws-logging/*"
            ]
        }
    ]
 }
