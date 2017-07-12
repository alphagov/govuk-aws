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

# We're going to CD into $PROJECT_DIR so make paths relative to that.
DATA_DIR="../../data"
COMMON_STACK_DATA_FILE="${DATA_DIR}/common/${STACKNAME}.tfvars"

PROJECT_DATA_DIR="${DATA_DIR}/${PROJECT}"
STACK_DATA_FILE="${PROJECT_DATA_DIR}/${STACKNAME}.tfvars"
COMMON_PROJECT_DATA_FILE="${PROJECT_DATA_DIR}/common.tfvars"

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

  if [[ -z $STACKNAME ]]
  then
    echo 'Specify the name of the ".tfvars" and ".backend" files.'
    HELP=1
  elif [[ $CMD == "init" ]] && [[ ! -f $PROJECT_DIR/$BACKEND_FILE ]]
  then
    echo "Could not find backend file '$PROJECT_DIR/$BACKEND_FILE'"
    HELP=1
  else

    if [[ ! -f $PROJECT_DIR/$STACK_DATA_FILE ]]
    then
      echo "Could not find tfvars file '$PROJECT_DIR/$STACK_DATA_FILE'"
      HELP=1
    fi

    if [[ ! -f $PROJECT_DIR/$COMMON_STACK_DATA_FILE ]]
    then
      echo "Could not find tfvars file '$PROJECT_DIR/$COMMON_STACK_DATA_FILE'"
      HELP=1
    fi
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

cd "$PROJECT_DIR"

# Actually run the command
if [[ $CMD == 'init' ]]
then
  terraform "$CMD" \
            -backend-config "$BACKEND_FILE"

elif [ -a "${COMMON_PROJECT_DATA_FILE}" ]
then
  terraform "$CMD" \
            -var-file "$STACK_DATA_FILE" \
            -var-file "$COMMON_STACK_DATA_FILE" \
            -var-file "$COMMON_PROJECT_DATA_FILE"

else
  terraform "$CMD" \
            -var-file "$STACK_DATA_FILE" \
            -var-file "$COMMON_STACK_DATA_FILE"
fi
