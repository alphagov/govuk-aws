{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govuk-${aws_environment}-aws-logging/*",
      "Principal": {
        "AWS": [
          "${aws_account_id}"
        ]
      }
    }
  ]
}
