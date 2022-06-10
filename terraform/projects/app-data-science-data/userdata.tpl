#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y awscli
sudo apt install -y htop
sudo apt install -y jq

# Allow SSH access
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1v8UTV0pOjSjZXnvQaWH/m5sOluCQGxeLU8NAbMa20lcazUDhEnQqjQ8SFvfMC06Zu8LWRMMPj3bIdS9I9G7ETWIq4Q8NdHEuOpgBJTcKsiL76hBVyQGWD682xfl4WhAHygsyN6qRGJg8YvkC5sAhYd7nu/9sfI8erc1S7mFt2zzT/4N4ULlI2vHgWGhePPJOfRz7cGi1nxe/WzlYNURVfR0YQfYsxI4vRwjSM0xDelTwKDbb5D1PgcTYx3c2bnrMcQ4FSA7iAyvJJnLSRCcxaCF8XjokR8gBg7Dp9tims0Amjee4J/S1v4ty3Pi8Hm590ZrmuvyVC8KEajCmUnD4JvUAPM7hZYKtLbUsHtR5rF43Ot9gadGV1FF8xEmcMvI0NuqiSuTRV/GPjHxPh+5U5uxrNqODUeTiLHH6m2+Cb55ud5aJJGkbg6nCM2LsWuTN3vbaIwlCxheEdZtp0HLi1XSo6WRiUPKuUpO4a/EX8h9zP+Nd1yeT/9xcyMMFAeieufV3PUjr/7TtG4KpgqzL0C9blWLaYUu9fa7/xT9jJg3yJIFvtidEXtiYvf56tfIr6wWxPkNNYIS5SEarCwI6AoMgMG0geicgzwmPBczovX62IN3lUDskLT0LGo8eliadEeaYCnQ1E3NS2rYwluTdPDYpqIYPH1Vb6MwGajmQBw== kelvin.gan@digital.cabinet-office.gov.uk" >> /home/ubuntu/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDvuBdxXkJ2Htbt47fm/CV7+uQLOu//OJ7tJv4mlyM0nChhvvI56ZjfYRCdcZNH+eFXzUDUDh1/HK9J8tA2J/ZTg/OqS+UMylQPdc4+LxPHDenhZjvCigf0Uf4ISJdprTCPJj11I/wc7bq1m6C3HGwK5DWAmSIOh7rqLDhuDIZIKdlx3nz8DEAmUFutcA//3sCfHSd8n3B6Rvpzhw5wqqJhG1nS7upJir3lew+XHt+anu6J17iGHTKKuSlZ9ZgXP7poQPizIjIK7sAkI6S45gLcKtJpbMd5pt8Ze80GcH5qoycylz93kUhy8jQJUAR97eDxh7odaFOX0y+Am2EcDJ33PsjDu9QCqJOQu0NiXWLobRIyqtDo08cdDg7yBYgAg5GuPAska/lCG9SFI1gYe7DNRB3LLvBZ4zKwhbiaQ2wdS4K0o4P1OAXdHq2Jp2XcG0jFERdI677v3uUcVEAuQ7GLVHoVKLpdj6+6IbWnh6j5WxVBLaXY2wLMC+dU60M2F1F19ixDEHNb2TUU7f5WIQuJH0N1u+lM3cDjba5cRQuMXDzlaHEwl8XjmHRGC1nwCdTtiNNAbmRe9sX8myXtbnYG0MgUcLkzd0YjVNQXv5jmmvvrRR80Zj2etTQmLQcOKwFkMScQCT9PJenj8RCm+DeCyT+TpRigxmD/6ztr8lHFzw== max.froumentin@digital.cabinet-office.gov.uk" >> /home/ubuntu/.ssh/authorized_keys

sudo locale-gen en_GB.UTF-8

# Install and upgrade pip
sudo apt install -y python-pip

# Upgrade pip
pip install --upgrade pip

# Install dependencies
pip install awscli

# Install Python 3.7
sudo add-apt-repository ppa:deadsnakes/ppa -y && sudo apt-get update
sudo apt-get install -y python3.7
sudo apt install -y python3.7-dev
sudo apt install -y python3-pip
sudo apt install -y libpq-dev
sudo apt install -y libicu-dev

sudo su - ubuntu

## Set-up BigQuery access
echo "$(aws secretsmanager get-secret-value --secret-id related_links-BIG_QUERY_SERVICE_ACCOUNT_KEY --query "SecretString" --region eu-west-1 | jq -r '.')" > /var/tmp/bigquery.json
chmod 400 /var/tmp/bigquery.json

# Create Python 3.7 virtual environment
cd /var
mkdir envs
cd envs
sudo apt install -y virtualenv
virtualenv -p python3.7 python37
source python37/bin/activate
pip install csvkit

# Create data dir
sudo mkdir /var/data
sudo chown -R ubuntu:ubuntu /var/data
sudo chmod g+s /var/data
cd /var/data

# Install MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list

sudo apt-get update -y
sudo apt-get install -y mongodb-org
sudo service mongod start

# Get content store backup
echo "Finding latest content backup..."
LATEST_CONTENT_BACKUP_PATH=$(aws s3api list-objects-v2 --bucket ${database_backups_bucket_name} --prefix mongo-api --query "Contents[?contains(Key, '-content_store_production.gz')]" | jq  -c "max_by(.LastModified)|.Key" | xargs)

echo "Downloading latest content store backup..."
aws s3 cp s3://${database_backups_bucket_name}/$LATEST_CONTENT_BACKUP_PATH /var/data/latest_content_store_backup.gz

# Extract content store backup
cd /var/data
tar -xvf latest_content_store_backup.gz
ls -lat content_store_production

# Restore content store data to MongoDb
mongorestore -d content_store -c content_items /var/data/content_store_production/content_items.bson

# Get Github deploy key and update permissions
/usr/local/bin/aws ssm get-parameter --name govuk_knowledge_graph_github_deploy_key --query "Parameter.Value" --region eu-west-1 --with-decryption | jq -r '.' > kg_id_rsa
chmod 600 kg_id_rsa

# Add Github deploy key to ssh agent
eval `ssh-agent -s`
ssh-add /var/data/kg_id_rsa

# Accept Github SSH fingerprint
ssh -T git@github.com -o StrictHostKeyChecking=no

# Download knowledge graph repo
mkdir /var/data/github
cd /var/data/github
git clone git@github.com:alphagov/govuk-knowledge-graph.git

# Set correct permissions for build data script
cd govuk-knowledge-graph
chmod +x ./build_knowledge_graph_data

# Run knowledge graph build script
touch /var/tmp/data_generation_process.log
./build_knowledge_graph_data -d ${data_infrastructure_bucket_name} > /var/tmp/data_generation_process.log 2>&1

# Copy logs across to S3
date_today=$(date '+%F')
aws s3 cp /var/tmp/data_generation_process.log s3://${data_infrastructure_bucket_name}/knowledge-graph/$date_today/data_generation_process.log
aws s3 cp /var/log/cloud-init-output.log s3://${data_infrastructure_bucket_name}/knowledge-graph/$date_today/cloud-init-output.log
