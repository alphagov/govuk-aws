#!/usr/bin/env bash

# Ubuntu
apt-get update -qq
apt-get -y upgrade
##############

apt-get install -y awscli jq

INSTANCE_ID=$(ec2metadata --instance-id)
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
TAGS=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=tag-key,Values=aws_*" --region=$REGION --output=json | jq -r '.Tags[] | [.Key, .Value] | @csv' | tr -d '"')

mkdir -p /etc/facter/facts.d/

for I in $TAGS
do
  KEY=$(echo $I | cut -d"," -f1)
  VALUE=$(echo $I | cut -d"," -f2)
  echo $KEY=$VALUE > /etc/facter/facts.d/$KEY.txt
done

# Add search domain for the local project. This allows local
# services like puppet to resolve
PROJECT=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=tag-key,Values=Project" --region=$REGION --output=json | jq -r '.Tags[] | .Value ')
sed -r -i "s/^search(.*)$/search\1 ${PROJECT}.internal/g" /etc/resolv.conf

# Append addition user-data script
${additional_user_data_script}
