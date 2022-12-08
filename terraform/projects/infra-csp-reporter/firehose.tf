resource "aws_kinesis_firehose_delivery_stream" "delivery_stream" {
  name        = "govuk-${var.aws_environment}-csp-reports-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.csp_reports.arn

    prefix              = "reports/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    error_output_prefix = "errors/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"

    buffer_size     = 64
    buffer_interval = 600

    data_format_conversion_configuration {
      input_format_configuration {
        deserializer {
          open_x_json_ser_de {}
        }
      }

      output_format_configuration {
        serializer {
          orc_ser_de {}
        }
      }

      schema_configuration {
        database_name = aws_glue_catalog_table.reports.database_name
        role_arn      = aws_iam_role.firehose_role.arn
        table_name    = aws_glue_catalog_table.reports.name
      }
    }
  }

  tags = {
    aws_environment = var.aws_environment
    project         = local.project_name
  }

  depends_on = [aws_iam_role_policy.firehose_glue_policy]
}

resource "aws_iam_role" "firehose_role" {
  name = "govuk-${var.aws_environment}-csp-reports-firehose-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# The firehose role policies are distinct so that we can apply this one
# before the kinesis delivery stream is set-up, as we need to use this access
# to create the delivery stream. The other ones aren't needed before the
# delivery stream's creation
resource "aws_iam_role_policy" "firehose_glue_policy" {
  name = "govuk-${var.aws_environment}-csp-reports-firehose-glue-policy"
  role = aws_iam_role.firehose_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "glue:GetTable",
        "glue:GetTableVersion",
        "glue:GetTableVersions"
      ],
      "Resource": [
        "arn:aws:glue:${var.aws_region}:${data.aws_caller_identity.current.account_id}:catalog",
        "${aws_glue_catalog_database.csp_reports.arn}",
        "${aws_glue_catalog_table.reports.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "firehose_bucket_policy" {
  name = "govuk-${var.aws_environment}-csp-reports-firehose-bucket-policy"
  role = aws_iam_role.firehose_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.csp_reports.id}",
        "arn:aws:s3:::${aws_s3_bucket.csp_reports.id}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords",
        "kinesis:ListShards"
      ],
      "Resource": "${aws_kinesis_firehose_delivery_stream.delivery_stream.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "firehose_kinesis_policy" {
  name = "govuk-${var.aws_environment}-csp-reports-firehose-kinesis-policy"
  role = aws_iam_role.firehose_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords",
        "kinesis:ListShards"
      ],
      "Resource": "${aws_kinesis_firehose_delivery_stream.delivery_stream.arn}"
    }
  ]
}
EOF
}
