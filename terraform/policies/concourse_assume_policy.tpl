{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${concourse_aws_account_id}:role/cd-govuk-tools-concourse-worker"
      },
      "Effect": "Allow"
    }
  ]
}
