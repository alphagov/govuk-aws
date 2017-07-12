#!/bin/bash
#
# This is a wrapper for terraform to make running projects easier.
# It takes three arguments: the command (e.g. "init" or "apply"), the project
# name (e.g. "govuk-networking" or "app-jumpbox") and the stack to run it in.
#

set -e

# Get the arguments
CMD=$1
PROJECT=$2
STACKNAME=$3

# Set up our locations
TERRAFORM_DIR='./terraform'

PROJECT_DIR="${TERRAFORM_DIR}/projects/${PROJECT}"
BACKEND_FILE="${STACKNAME}.backend"

DATA_DIR="../../data/${PROJECT}"
STACK_DATA_FILE="${DATA_DIR}/${STACKNAME}.tfvars"
COMMON_DATA_FILE="${DATA_DIR}/common.tfvars"

# Check we have all the arguments we need
if [[ $CMD = "-h" ]]
then
  HELP=1
else
  if [[ -z $CMD ]]
  then
    echo 'Specify the Terraform command to run, eg "init", "plan" or "apply".'
    HELP=1
  fi

  if [[ -z $PROJECT ]]
  then
    echo 'Specify which project to create, eg "govuk-networking".'
    HELP=1
  elif [[ ! -d $PROJECT_DIR ]]
  then
    echo "Could not find $PROJECT directory: $PROJECT_DIR"
    HELP=1
  fi

  # Now we know the project exists check everything else from there.
  cd "$PROJECT_DIR"

  if [[ -z $STACKNAME ]]
  then
    echo 'Specify the name of the ".tfvars" and ".backend" files.'
    HELP=1
  elif [[ $CMD == "init" ]] && [[ ! -f $BACKEND_FILE ]]
  then
    echo "Could not find backend file '$BACKEND_FILE'"
    HELP=1
  elif [[ ! -f $STACK_DATA_FILE ]]
  then
    echo "Could not find tfvars file '$STACK_DATA_FILE'"
    HELP=1
  fi
fi

if [[ $HELP == "1" ]] || [[ $CMD == "-h" ]]
then
  echo -e "$0 [CMD] [PROJECT] [STACKNAME]\n"
  echo -e 'CMD\t\t The Terraform command to run, eg "init", "plan" or "apply".'
  echo -e 'PROJECT\t\t Specify which project to create, eg "govuk-networking".'
  echo -e 'STACKNAME\t Specify the name of the ".tfvars" and ".backend" files.'
  exit
fi

# Actually run the command
if [[ $CMD == 'init' ]]
then
  terraform "$CMD" \
            -backend-config "$BACKEND_FILE"

elif [ -a "${COMMON_DATA_FILE}" ]
then
  terraform "$CMD" \
            -var-file "$STACK_DATA_FILE" \
            -var-file "$COMMON_DATA_FILE"

else
  terraform "$CMD" \
            -var-file "$STACK_DATA_FILE"
fi
