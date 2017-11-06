{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": { 
      "Service": "firehose.amazonaws.com"
    },
    "Action": "sts:AssumeRole",
    "Condition": {
      "StringEquals": { 
        "sts:ExternalId":"${aws_account_id}"
      }
    }
  }
}
