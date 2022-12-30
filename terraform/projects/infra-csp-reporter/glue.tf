resource "aws_glue_catalog_database" "csp_reports" {
  name        = "csp_reports"
  description = "Used to browse the Content Security Policy violations"
}

resource "aws_iam_role" "glue_role" {
  name = "govuk-${var.aws_environment}-csp-reports-glue-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_policy" {
  name = "govuk-${var.aws_environment}-csp-reports-glue-policy"
  role = aws_iam_role.glue_role.id

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
    }
  ]
}
EOF
}

resource "aws_glue_crawler" "csp_reports" {
  name          = "Content Security Policy reports"
  description   = "Crawls the CSP logs for allowing Athena querying"
  database_name = aws_glue_catalog_database.csp_reports.name
  role          = aws_iam_role.glue_role.name
  schedule      = "cron(15 * * * ? *)" # Run every hour as we're not sure how frequently we'll get reports

  tags = {
    aws_environment = var.aws_environment
    project         = local.project_name
  }

  s3_target {
    path = "s3://${aws_s3_bucket.csp_reports.bucket}/reports"
  }

  schema_change_policy {
    delete_behavior = "DELETE_FROM_DATABASE"
    update_behavior = "LOG"
  }

  configuration = <<EOF
{
  "Version": 1.0,
  "CrawlerOutput": {
    "Partitions": {
      "AddOrUpdateBehavior": "InheritFromTable"
    }
  }
}
EOF
}

resource "aws_glue_catalog_table" "reports" {
  name          = "reports"
  description   = "Allows access to CSP reports"
  database_name = aws_glue_catalog_database.csp_reports.name
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    compressed    = true
    location      = "s3://${aws_s3_bucket.csp_reports.bucket}/reports/"
    input_format  = "org.apache.hadoop.hive.ql.io.orc.OrcInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.orc.OrcSerde"
    }

    // These columns correlate with the CspReportsToFirehose Lambda
    // If you add a new column, add it to the end otherwise existing data
    // can end up in the wrong column.
    columns {
      name    = "time"
      type    = "timestamp"
      comment = "Time report was received"
    }

    columns {
      name    = "document_uri"
      type    = "string"
      comment = "URI of the document that initiated the CSP report"
    }

    columns {
      name    = "referrer"
      type    = "string"
      comment = "Referrer to the document"
    }

    columns {
      name    = "blocked_uri"
      type    = "string"
      comment = "URI of the resource that violates the CSP policy"
    }

    columns {
      name    = "effective_directive"
      type    = "string"
      comment = "The CSP directive that causes the violation"
    }

    columns {
      name    = "violated_directive"
      type    = "string"
      comment = "The CSP directive that causes the violation, typically an alias of effective_directive"
    }

    columns {
      name    = "disposition"
      type    = "string"
      comment = "Whether this was a report or a block"
    }

    columns {
      name    = "sample"
      type    = "string"
      comment = "Sample code from the violation"
    }

    columns {
      name    = "line_number"
      type    = "int"
      comment = "The line number from the document that triggered the report"
    }

    columns {
      name    = "status_code"
      type    = "int"
      comment = "HTTP status code of the violation resource"
    }

    columns {
      name    = "source_ip"
      type    = "string"
      comment = "IP of the device that requested the resource"
    }

    columns {
      name    = "user_agent"
      type    = "string"
      comment = "User agent from the device that requested the resource"
    }

    columns {
      name    = "original_policy"
      type    = "string"
      comment = "The policy that was in effect when this report was made"
    }
  }

  // these correspond to directory ordering of:
  // /year=YYYY/month=MM/date=DD/file.log.gz
  partition_keys {
    name = "year"
    type = "int"
  }

  partition_keys {
    name = "month"
    type = "int"
  }

  partition_keys {
    name = "date"
    type = "int"
  }

  parameters = {
    classification  = "orc"
    compressionType = "snappy"
    typeOfDate      = "file"
  }
}
