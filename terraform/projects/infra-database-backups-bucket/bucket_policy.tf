resource "aws_s3_bucket_policy" "cross_account_access" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.cross_account_access.json
}

data "aws_iam_policy_document" "cross_account_access" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        "210287912431", # integration
        "696911096973", # staging
        "172025368201", # production
      ]
    }
    actions   = ["s3:Get*", "s3:List*"]
    resources = [aws_s3_bucket.main.arn, "${aws_s3_bucket.main.arn}/*"]
  }
}
