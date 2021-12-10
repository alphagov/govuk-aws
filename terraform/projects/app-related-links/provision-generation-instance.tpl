#!/bin/bash

set -eo pipefail

# Install updates and required packages
sudo apt-get update -y
sudo apt-get install -y awscli jq

echo "CONTENT_STORE_BUCKET=\"${database_backups_bucket_name}\"" >> /home/ubuntu/.profile
echo "RELATED_LINKS_BUCKET=\"${related_links_bucket_name}\"" >> /home/ubuntu/.profile
echo "$(aws secretsmanager get-secret-value --secret-id related_links-BIG_QUERY_SERVICE_ACCOUNT_KEY --query "SecretString" --region eu-west-1 | jq -r '.')" > /var/tmp/bigquery.json
chmod 400 /var/tmp/bigquery.json
chown ubuntu:ubuntu /var/tmp/bigquery.json
