/**
* ## Module: aws/iam/gds_user_role
*
* This module creates a set of IAM roles based on a list of user ARNs.
* Each newly-created IAM role is then associated with a set of of IAM policies.
* These new IAM role and policy associations form a category of users with the
* same privileges.
*
*/


variable "role_suffix" {
  type        = string
  description = "Suffix of the role name"
}

variable "role_user_arns" {
  type        = list
  description = "List of ARNs of external users that can assume the role"
}

variable "role_policy_arns" {
  type        = list
  description = "List of ARNs of policies to attach to the role"
  default     = []
}

variable "restrict_to_gds_ips" {
  default = false
}

variable "office_ips" {
  type        = list
  description = "An array of CIDR blocks that will be allowed offsite access."
}

# Resources
#--------------------------------------------------------------

locals {
  user_and_policy_associations = [
    for pair in setproduct(var.role_user_arns, var.role_policy_arns) :
    {
      user_arn : pair[0],
      policy_arn : pair[1],
      role_name : "${regex("^.*/(.+)@.*$", pair[0])[0]}-${var.role_suffix}",
      policy_name : regex("^.*/(.+)$", pair[1])[0],
    }
  ]

  gds_ip_restriction_policy_fragment = <<-EOF
  "IpAddress": {
    "aws:SourceIp": var.office_ips
  },
  EOF

  maybe_source_ip_restriction = var.restrict_to_gds_ips ? local.gds_ip_restriction_policy_fragment : ""

  roles_and_user_arns = {
    for user_arn in var.role_user_arns : "${regex("/(.+)@", user_arn)[0]}-${var.role_suffix}" => user_arn
  }
}

resource "aws_iam_role" "gds_user_role" {
  for_each = local.roles_and_user_arns

  name                 = each.key
  max_session_duration = 28800
  assume_role_policy   = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "${each.value}"
          ]
        },
        "Action": "sts:AssumeRole",
        "Condition": {
          ${local.maybe_source_ip_restriction}
          "Bool": {
            "aws:MultiFactorAuthPresent": "true"
          }
        }
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "gds_user_role_policy_attachments" {
  for_each = {
    for association in local.user_and_policy_associations : "${association.role_name}_${association.policy_name}" => association
  }

  role       = each.value.role_name
  policy_arn = each.value.policy_arn

  depends_on = [aws_iam_role.gds_user_role]
}

output "roles_and_arns" {
  value       = { for role in aws_iam_role.gds_user_role : role.name => role.arn }
  description = "Map of '$username-$role' to role ARN. e.g. {'joe.bloggs-admin': 'arn:aws:iam::123467890123:role/joe.bloggs-admin'}"
}
