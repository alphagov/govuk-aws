#!/bin/bash

set -eo pipefail

# Install updates and required packages
sudo apt-get update -y
sudo apt-get install -y awscli jq gnupg2

echo "RELATED_LINKS_BUCKET=\"${related_links_bucket_name}\"" >> /home/ubuntu/.profile
echo "PUBLISHING_API_URI=\"${publishing_api_uri}\"" >> /home/ubuntu/.profile
echo "PUBLISHING_API_BEARER_TOKEN=\"$(aws secretsmanager get-secret-value --secret-id related_links_PUBLISHING_API_BEARER_TOKEN --query "SecretString" --region eu-west-1 | jq -r '.')\"" >> /home/ubuntu/.profile
