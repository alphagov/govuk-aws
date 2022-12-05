#!/bin/bash
#
# Update docs across all projects and modules
#
if [[ ! $(command -v terraform-docs) ]]; then
  echo "Must install terraform-docs: https://github.com/segmentio/terraform-docs"
  exit 1
fi

for i in $(find terraform/ -name main.tf |sed 's/\/main.tf//g'); do
  terraform-docs --lockfile=false md $i > $i/README.md
done
