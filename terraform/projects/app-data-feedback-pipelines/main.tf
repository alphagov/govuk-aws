/**
* ## Project: app-data-feedback-pipelines
*
* Data feedback pipelines
*
* Smart Survey and Zendesk feedback pipelines, which extract user feedback, cleanse it and push to Google BigQuery.
*/
variable "aws_environment" {
  type        = "string"
  description = "AWS environment"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

# Resources
# --------------------------------------------------------------

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "invoke_feedback_pipelines_lambda_policy_document" {
  statement {
    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      "arn:aws:lambda:eu-west-1:${data.aws_caller_identity.current.account_id}:function:smart-survey-data-pipeline",
      "arn:aws:lambda:eu-west-1:${data.aws_caller_identity.current.account_id}:function:zendesk-data-pipeline",
    ]
  }
}

data "aws_iam_policy_document" "update_feedback_pipelines_lambda_policy_document" {
  statement {
    actions = [
      "lambda:UpdateFunctionCode",
    ]

    resources = [
      "arn:aws:lambda:eu-west-1:${data.aws_caller_identity.current.account_id}:function:smart-survey-data-pipeline",
      "arn:aws:lambda:eu-west-1:${data.aws_caller_identity.current.account_id}:function:zendesk-data-pipeline",
    ]
  }
}

data "aws_iam_policy_document" "smart_survey_data_pipeline_read_ssm_policy_document" {
  statement {
    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_big_query_data_service_user_key_file",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_smart_survey_pipeline_bigquery_dataset",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_smart_survey_pipeline_bigquery_project",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_smart_survey_pipeline_bigquery_tablename",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_smart_survey_pipeline_smart_survey_api_endpoint",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_smart_survey_pipeline_smart_survey_api_secret",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_smart_survey_pipeline_smart_survey_api_token",
    ]
  }
}

data "aws_iam_policy_document" "zendesk_data_pipeline_read_ssm_policy_document" {
  statement {
    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_big_query_data_service_user_key_file",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_zendesk_pipeline_bigquery_dataset",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_zendesk_pipeline_bigquery_project",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_zendesk_pipeline_bigquery_tablename",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_zendesk_pipeline_zendesk_password",
      "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/govuk_zendesk_pipeline_zendesk_username",
    ]
  }
}

data "aws_iam_policy_document" "lambda_write_to_cloudwatch_logs_policy_document" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "feedback_pipelines_lambda_execution_role" {
  name               = "feedback_pipelines_lambda_execution_role"
  assume_role_policy = "${file("${path.module}/../../policies/lambda_assume_policy.json")}"
}

resource "aws_iam_policy" "invoke_feedback_pipelines_lambda_policy" {
  name   = "invoke_feedback_pipelines_lambda_policy"
  policy = "${data.aws_iam_policy_document.invoke_feedback_pipelines_lambda_policy_document.json}"
}

resource "aws_iam_policy" "update_feedback_pipelines_lambda_policy" {
  name   = "update_feedback_pipelines_lambda_policy"
  policy = "${data.aws_iam_policy_document.update_feedback_pipelines_lambda_policy_document.json}"
}

resource "aws_iam_policy" "smart_survey_data_pipeline_read_ssm_policy" {
  name   = "smart_survey_data_pipeline_read_ssm_policy"
  policy = "${data.aws_iam_policy_document.smart_survey_data_pipeline_read_ssm_policy_document.json}"
}

resource "aws_iam_policy" "zendesk_data_pipeline_read_ssm_policy" {
  name   = "zendesk_data_pipeline_read_ssm_policy"
  policy = "${data.aws_iam_policy_document.zendesk_data_pipeline_read_ssm_policy_document.json}"
}

resource "aws_iam_policy" "lambda_write_to_cloudwatch_logs_policy" {
  name   = "lambda_write_to_cloudwatch_logs_policy"
  policy = "${data.aws_iam_policy_document.lambda_write_to_cloudwatch_logs_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "invoke_feedback_pipelines_lambda_role_attachment" {
  role       = "${data.terraform_remote_state.app_related_links.concourse_role_name}"
  policy_arn = "${aws_iam_policy.invoke_feedback_pipelines_lambda_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "update_feedback_pipelines_lambda_role_attachment" {
  role       = "${data.terraform_remote_state.app_related_links.concourse_role_name}"
  policy_arn = "${aws_iam_policy.update_feedback_pipelines_lambda_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "smart_survey_data_pipeline_read_ssm_role_attachment" {
  role       = "${aws_iam_role.feedback_pipelines_lambda_execution_role.name}"
  policy_arn = "${aws_iam_policy.smart_survey_data_pipeline_read_ssm_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "zendesk_data_pipeline_read_ssm_role_attachment" {
  role       = "${aws_iam_role.feedback_pipelines_lambda_execution_role.name}"
  policy_arn = "${aws_iam_policy.zendesk_data_pipeline_read_ssm_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda_write_to_cloudwatch_logs_role_attachment" {
  role       = "${aws_iam_role.feedback_pipelines_lambda_execution_role.name}"
  policy_arn = "${aws_iam_policy.lambda_write_to_cloudwatch_logs_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "read_write_data_infrastructure_bucket_role_attachment" {
  role       = "${data.terraform_remote_state.app_related_links.concourse_role_name}"
  policy_arn = "${data.terraform_remote_state.app_knowledge_graph.read_write_data_infrastructure_bucket_policy_arn}"
}

resource "aws_lambda_function" "smart_suvey_data_pipeline" {
  function_name = "smart-survey-data-pipeline"
  role          = "${aws_iam_role.feedback_pipelines_lambda_execution_role.arn}"
  handler       = "smart_survey_lambda_handler.lambda_handler"

  s3_bucket = "${data.terraform_remote_state.app_knowledge_graph.data-infrastructure-bucket_name}"
  s3_key    = "lambdas/feedback-data-pipelines.zip"

  memory_size = 1024
  runtime     = "python3.7"
  timeout     = 600
}

resource "aws_lambda_function" "zendesk_data_pipeline" {
  function_name = "zendesk-data-pipeline"
  role          = "${aws_iam_role.feedback_pipelines_lambda_execution_role.arn}"
  handler       = "zendesk_lambda_handler.lambda_handler"

  s3_bucket = "${data.terraform_remote_state.app_knowledge_graph.data-infrastructure-bucket_name}"
  s3_key    = "lambdas/feedback-data-pipelines.zip"

  memory_size = 1024
  runtime     = "python3.7"
  timeout     = 600
}
