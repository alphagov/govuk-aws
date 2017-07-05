# 12. Security Groups in Terraform

Date: 2017-07-05

## Status

Accepted

## Context

There are two methods of defining security groups for AWS in Terraform and they are distinguished by how you add rules: in-line and separate. Using in-line rules keeps the definition close to the resource but when ever a rule is changed Terraform will re-generate the entire resource. Using separate rules Terraform will only make the single rule change but there is greater boilerplate and separation between the group resource and the rule resource.

## Decision

Security groups will be defined separate to their rules.

Additionally each security group will be defined, in its entirety, in a single file.

## Consequences

Terraform should only create the specific rules that have changed when run.

There will be a larger 'distance' between the definition of a group and its rules.

Separate files may be harder to follow if there is heavy cross-referencing of security groups.

There may be a performance impact to Terraform depending on how it treats forward references.

