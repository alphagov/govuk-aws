#!/bin/bash
#
# Update docs across all projects and modules
#
set -euo pipefail

if ! terraform-docs -v; then
  echo >&2 "Must install terraform-docs: https://github.com/terraform-docs/terraform-docs"
  exit 1
fi

this_script_dir=$(dirname -- "${BASH_SOURCE[0]}")
terraform_dir="${this_script_dir}/../terraform"

find "$terraform_dir" -type f -name main.tf | while read -r main_tf; do
  module=$(dirname "$main_tf")
  terraform-docs --lockfile=false md "$module" > "${module}/README.md" &
done
wait

# Ugly workaround for lack of shell job control when running on GitHub Actions.
while pgrep terraform-docs >/dev/null; do sleep 1; done
