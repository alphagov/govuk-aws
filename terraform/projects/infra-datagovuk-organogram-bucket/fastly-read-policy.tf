provider "fastly" {
  # We only want to use fastly's data API
  api_key = "test"
}

data "fastly_ip_ranges" "fastly" {}

data "aws_iam_policy_document" "s3_fastly_read_policy_doc" {
  statement {
    sid     = "S3FastlyReadBucket"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.datagovuk-organogram.id}",
      "arn:aws:s3:::${aws_s3_bucket.datagovuk-organogram.id}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"

      values = [
        "${data.fastly_ip_ranges.fastly.cidr_blocks}",
        "${var.s3_bucket_read_ips}",
      ]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
