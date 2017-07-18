#!/usr/bin/env bash
# This script is for deploying Puppet to a Puppetmaster if you don't
# already have a Jenkins instance.
set -e

while getopts "e:d:p:g:t:h" option
do
  case $option in
    h ) HELP=1 ;;
    e ) ENVIRONMENT=$OPTARG ;;
    d ) DEPLOYMENT_REPO=$OPTARG ;;
    p ) PUPPET_REPO=$OPTARG ;;
    g ) GPG_KEY=$OPTARG ;;
    t ) TARGET=$OPTARG
  esac
done

if [[ -z $ENVIRONMENT ]]
then
  echo "No environment set"
  HELP=1
fi

if [[ -z $GPG_KEY ]]
then
  echo "No path to GPG key set"
  HELP=1
fi

if [[ -z $DEPLOYMENT_REPO ]]
then
  echo "No local deployment repo path set"
  HELP=1
else
  if [[ ! -d $DEPLOYMENT_REPO ]]
  then
    echo "The local deployment repository does not exist at the path specified"
    HELP=1
  fi
fi

if [[ -z $PUPPET_REPO ]]
then
  echo "No local Puppet repo path set"
  HELP=1
else
  if [[ ! -d $PUPPET_REPO ]]
  then
    echo "The local Puppet repository does not exist at the path specified"
    HELP=1
  fi
fi

if [[ -z $TARGET ]]
then
  echo "No target machine set"
  HELP=1
fi

if [[ "$HELP" = "1" ]]
then
  echo "Deploy Puppet to a Puppetmaster"
  echo "-e environment name"
  echo "-d deployment repo path"
  echo "-p Puppet repo path"
  echo "-t target machine address"
  echo "-g path to Puppetmaster GPG key"
  echo "-h display this help text"
  exit 0
fi

TARGET_MACHINE=ubuntu@$TARGET

ssh-copy-id $TARGET_MACHINE

# ${PUPPET_REPO%/} removes any trailing slash so that rsync will copy the
# directory correctly.
rsync -avz --exclude='.git/' --exclude='development-vm/' --exclude='training-vm/' ${PUPPET_REPO%/} $TARGET_MACHINE:
rsync -avz --exclude='.git/' $DEPLOYMENT_REPO/puppet/hieradata_aws/* $TARGET_MACHINE:govuk-puppet/hieradata_aws/
rsync -avz --exclude='.git/' $GPG_KEY $TARGET_MACHINE:gpgkey
rsync -avz --exclude='.git/' aws-copy-puppet-setup.sh $TARGET_MACHINE:

echo "Execute in Puppetmaster: sudo ./aws-copy-puppet-setup.sh -e $ENVIRONMENT"
