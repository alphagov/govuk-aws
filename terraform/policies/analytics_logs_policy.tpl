{
  "Version": "2012-10-17",
  "Statement": [
    {
       "Effect":"Allow",
       "Action":[
          "s3:GetObject",
          "s3:ListBucket"
       ],
       "Resource":[
          "${bucket_arn}*"
       ]
    }
  ]
}
