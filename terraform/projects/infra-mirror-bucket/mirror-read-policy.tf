provider "fastly" {
  # We only want to use fastly's data API
  api_key = "test"
}

data "fastly_ip_ranges" "fastly" {}

data "external" "pingdom" {
  program = ["/bin/bash", "${path.module}/pingdom_probe_ips.sh"]
}

data "aws_iam_policy_document" "s3_mirrors_read_policy_doc" {
  statement {
    sid     = "S3FastlyReadBucket"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-1.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-1.id}/*",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-2.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-2.id}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${data.fastly_ip_ranges.fastly.cidr_blocks}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid     = "S3PingdomReadBucket"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-1.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-1.id}/*",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-2.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-2.id}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${split(",",data.external.pingdom.result.pingdom_probe_ips)}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
