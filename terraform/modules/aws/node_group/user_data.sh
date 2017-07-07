#!/usr/bin/env bash

# Ubuntu
apt-get update -qq
apt-get -y upgrade
##############

mkdir -p /etc/facter/facts.d/
echo aws_migration=puppetmaster > /etc/facter/facts.d/aws_migration.txt
echo aws_hostname=puppetmaster-1 > /etc/facter/facts.d/aws_hostname.txt

# Append addition user-data script
${additional_user_data_script}
