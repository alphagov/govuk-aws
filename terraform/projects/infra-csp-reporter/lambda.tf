data "archive_file" "lambda_dist" {
  type        = "zip"
  source_file = "${path.module}/../../lambda/CspReportsToFirehose/index.mjs"
  output_path = "${path.module}/../../lambda/CspReportsToFirehose/CspReportsToFirehose.zip"
}

resource "aws_lambda_function" "lambda" {
  filename         = data.archive_file.lambda_dist.output_path
  source_code_hash = data.archive_file.lambda_dist.output_base64sha256

  function_name = "CspReportsToFirehose"
  description   = "Handles Content Security Policy reports, passing valid ones to Kinesis Firehose"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  environment {
    variables = {
      FIREHOSE_DELIVERY_STREAM = aws_kinesis_firehose_delivery_stream.delivery_stream.name
    }
  }

  tags = {
    aws_environment = var.aws_environment
    project         = local.project_name
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "govuk-${var.aws_environment}-csp-reports-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_service" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "govuk-${var.aws_environment}-csp-reports-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "firehose:*"
      ],
      "Resource": "${aws_kinesis_firehose_delivery_stream.delivery_stream.arn}"
    }
  ]
}
EOF
}

# AWS will automatically create a log group for the lambda at this location
# however that will have logs that are retained forever
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 30

  tags = {
    aws_environment = var.aws_environment
    project         = local.project_name
  }
}
