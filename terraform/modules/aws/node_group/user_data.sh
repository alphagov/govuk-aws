#!/usr/bin/env bash

#
# Snippet: base
#

echo "[$(date '+%H:%M:%S %d-%m-%Y')] START SNIPPET: base"

# Source DISTRIB_* env vars
. /etc/lsb-release

echo "[$(date '+%H:%M:%S %d-%m-%Y')] base: configure locales ..."
export DEBIAN_FRONTEND=noninteractive
echo "LC_ALL=en_GB.UTF-8" > /etc/environment
locale-gen "en_GB.UTF-8"
dpkg-reconfigure locales

echo "[$(date '+%H:%M:%S %d-%m-%Y')] base: regenerate the servers hosts keys to ensure they are unique ..."
rm -f /etc/ssh/ssh_host*key*
dpkg-reconfigure openssh-server

echo "[$(date '+%H:%M:%S %d-%m-%Y')] base: install Puppet repository ..."
TMPFILE=$(mktemp)
wget -qO $TMPFILE http://apt.puppetlabs.com/puppetlabs-release-$DISTRIB_CODENAME.deb
dpkg -i $TMPFILE
rm $TMPFILE

echo "[$(date '+%H:%M:%S %d-%m-%Y')] base: ensure the packages are up to date ..."
apt-get update -qq
apt-get -y upgrade

echo "[$(date '+%H:%M:%S %d-%m-%Y')] base: install AWS cli ..."
apt-get install -y awscli jq

echo "[$(date '+%H:%M:%S %d-%m-%Y')] base: install LVM ..."
apt-get install -y lvm2

echo "[$(date '+%H:%M:%S %d-%m-%Y')] base: generate local facts ..."
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

echo "[$(date '+%H:%M:%S %d-%m-%Y')] base: add default user profile settings ..."
echo -e "\n# Default user settings" >> /etc/profile
echo "export AWS_DEFAULT_REGION=${REGION}" |tee -a /etc/profile

echo "[$(date '+%H:%M:%S %d-%m-%Y')] base: install Puppet ..."
apt-get -y install make ruby1.9.3 puppet='3.8.*' puppet-common='3.8.*'
service puppet stop

echo "[$(date '+%H:%M:%S %d-%m-%Y')] base: add search domain for local stack ..."
F_STACKNAME=$(facter aws_stackname)

if [[ -z $F_STACKNAME ]] ; then
  echo "ERROR aws_stackname is null"
else
  echo "append domain-search \""$F_STACKNAME".internal\";" >> /etc/dhcp/dhclient.conf
  dhclient -r; dhclient
fi

echo "[$(date '+%H:%M:%S %d-%m-%Y')] END SNIPPET: base"

# Append addition user-data script
${additional_user_data_script}
