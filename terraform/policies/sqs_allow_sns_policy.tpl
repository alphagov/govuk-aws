{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:SendMessage"
      ],
      "Effect": "Allow",
      "Principal": "*",
      "Resource": "${sqs_queue_arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${sns_topic_arn}"
        }
      }
    }
  ]
}
