{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "XRayRolePolicy",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${xray_daemon_user_arn}"
      },
      "Effect": "Allow"
    }
  ]
}
