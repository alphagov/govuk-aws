#!/bin/bash

set -eu

SUPPORTED_DISTROS=("trusty")
distro="$(lsb_release --codename --short)"

if ! [[ "${SUPPORTED_DISTROS[*]}" =~ $distro ]]
then
  echo "This distro isn't supported by this bootstrap script yet - aborting"
  exit 1
fi

az="$(
  curl --silent --show-error --fail \
  http://169.254.169.254/latest/meta-data/placement/availability-zone
)"
export AWS_REGION="${az:0:-1}"
export AWS_DEFAULT_REGION="${az:0:-1}"
instance_id="$(
  curl --silent --show-error --fail \
  http://169.254.169.254/latest/meta-data/instance-id
)"
instance_tags="$(
  aws ec2 describe-instances --instance-id "$instance_id" \
    | jq -r '.Reservations[] | .Instances[] | .Tags | map({"key": .Key, "value": .Value}) | from_entries'
)"
stackname="$(echo "$instance_tags" | jq -r .aws_stackname)"
environment="$(echo "$instance_tags" | jq -r .aws_environment)"
role="$(echo "$instance_tags" | jq -r .aws_migration)"

printf "EC2 instance ID: %s" "$instance_id"
printf "EC2 instance tags:\\n %s" "$instance_tags"

function get_ssm_parameter () {
  aws ssm get-parameter \
    --name "$1" \
    --with-decryption \
      | jq -r '.Parameter.Value'
}

# Establish SSH trust with Github - cache the public host key and the private
# deploy key that allows read-only access to the alphagov organization
get_ssm_parameter 'govuk_base64_github.com_hostkey' | base64 --decode >> /etc/ssh/ssh_known_hosts
get_ssm_parameter 'govuk_base64_github.com_ssh_readonly' | base64 --decode > /root/.ssh/id_rsa
chmod 400 /root/.ssh/id_rsa

# Import GPG for decrypting secrets in Hiera-EYAML
mkdir /etc/puppet/gpg
chmod 700 /etc/puppet/gpg
(
  get_ssm_parameter 'govuk_base64_staging_gpg_1_of_3'
  get_ssm_parameter 'govuk_base64_staging_gpg_2_of_3'
  get_ssm_parameter 'govuk_base64_staging_gpg_3_of_3'
) | base64 --decode | GNUPGHOME=/etc/puppet/gpg gpg --import --armor

# Clone Puppet repo into release directory based on current timestamp
puppet_release_dir="/usr/share/puppet/$environment/releases/$(date +%Y%m%d%H%M%S)"
puppet_current="/usr/share/puppet/$environment/current"

mkdir -p "$puppet_release_dir"
git clone --branch vagrant-decouple-govuk-provisioning git@github.com:alphagov/govuk-puppet.git "$puppet_release_dir"
ln -s "$puppet_release_dir" "$puppet_current"

# Clone secrets repo and copy secrets into 
mkdir -p /var/govuk
git clone git@github.com:alphagov/govuk-secrets.git /var/govuk/govuk-secrets

mkdir -p /etc/facter/facts.d
echo "aws_stackname=$stackname" > /etc/facter/facts.d/aws_stackname.txt
echo "aws_environment=$environment" > /etc/facter/facts.d/aws_environment.txt
echo "aws_migration=$role" > /etc/facter/facts.d/aws_migration.txt

gem install --no-rdoc --no-ri hiera-eyaml hiera-eyaml-gpg ruby_gpg
gem install --no-rdoc --no-ri librarian-puppet -v 2.2.3

cd "$puppet_current"
HOME=/root librarian-puppet install

mkdir -p /var/log/govuk
puppet apply \
  --trusted_node_data \
  --hiera_config "${puppet_current}/hiera_aws.yml" \
  --environment "$environment" \
  --modulepath "${puppet_current}/modules:${puppet_current}/vendor/modules" \
  --logdest /var/log/govuk/govuk_puppet_apply.log \
  "${puppet_current}/manifests/site.pp"

