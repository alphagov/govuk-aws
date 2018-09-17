#!/bin/bash

set -e

eval "$(jq -r '@sh "enable=\(.enable) db_instance_identifier=\(.db_instance_identifier)"')"

# shellcheck disable=SC2154
[[ "$enable" == "0" ]] && exit 0

# shellcheck disable=SC2154
jq="[
  .DBSnapshots | sort_by(.SnapshotCreateTime) | .[] |
  select(.DBInstanceIdentifier == \"${db_instance_identifier}\")
] | last | { arn: .DBSnapshotArn }"

aws rds describe-db-snapshots --snapshot-type shared --include-shared | jq "$jq"
