/**
* ## Project: database-backups-bucket
*
* This is used to provide and control access to the database backup bucket located in the Production environment.
* a) We have created individual resources that can be applied to individual projects.
* b) We have also restricted wich sub object can be accessed.
* c) The bucket gives read access to accounts from all three environments, but we believe that restricting at this level is sufficient.
*
*/

resource "aws_iam_policy" "mongo_api_database_backups_reader" {
  name        = "govuk-${var.aws_environment}-mongo-api_database_backups-reader-policy"
  policy      = "${data.aws_iam_policy_document.mongo_api_database_backups_reader.json}"
  description = "Allows reading the database_backups bucket"
}

data "aws_iam_policy_document" "mongo_api_database_backups_reader" {
  statement {
    sid = "MongoAPIReadBucket"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    # Need access to the top level of the tree.
    resources = [
      "arn:aws:s3:::${var.backup_source_bucket}",
    ]

    # We can now apply restictions on what can be accessed.
    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "mongo-api",
      ]
    }
  }
}

output "mongo_api_read_database_backups_bucket_policy_arn" {
  value       = "${aws_iam_policy.mongo_api_database_backups_reader.arn}"
  description = "ARN of the read mongo-api database_backups-bucket policy"
}
