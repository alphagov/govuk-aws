#!/bin/bash
#
# This is a wrapper for terraform to make running projects easier.
# It takes three arguments: the command (e.g. "init" or "apply"), the project
# name (e.g. "govuk-networking" or "app-jumpbox") and the stack to run it in.
#

set -e

function usage() {
  echo -e "usage: $0 [CMD] [PROJECT] [STACKNAME]\n"
  echo -e 'CMD\t\t The Terraform command to run, eg "init", "plan" or "apply".'
  echo -e 'PROJECT\t\t Specify which project to create, eg "govuk-networking".'
  echo -e 'STACKNAME\t Specify the name of the ".tfvars" and ".backend" files.'
}


function log_error() {
  echo -e "ERROR: $*\n"
  HELP=1
}

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

if [[ $CMD = "-h" ]]; then
  usage
  exit
fi

# Check we have all the arguments we need
if [[ -z $CMD ]];  then
  log_error 'Specify the Terraform command to run, eg "init", "plan" or "apply".'

fi

if [[ -z $PROJECT ]]; then
  log_error 'Specify which project to create, eg "govuk-networking".'

elif [[ ! -d $PROJECT_DIR ]]; then
  log_error "Could not find $PROJECT directory: $PROJECT_DIR"

fi

if [[ -z $STACKNAME ]]; then
  log_error 'Specify the stackname (prefix of the ".tfvars" and ".backend" files).'

elif [[ $CMD == "init" ]] && [[ ! -f $PROJECT_DIR/$BACKEND_FILE ]]; then
  log_error "Could not find backend file '$PROJECT_DIR/$BACKEND_FILE'"

elif [[ ! -f $PROJECT_DIR/$STACK_DATA_FILE ]] && \
     [[ ! -f $PROJECT_DIR/$COMMON_STACK_DATA_FILE ]]; then
  log_error 'Could not find any tfvar files. Looked for:\n' \
            "\t$PROJECT_DIR/$STACK_DATA_FILE \n " \
            "\t$PROJECT_DIR/$COMMON_STACK_DATA_FILE"
fi

# If there's been an error print the usage & exit
if [[ $HELP == "1" ]]; then
  usage
  exit
fi

# Run everything from the appropriate project
cd "$PROJECT_DIR"

# Actually run the command
if [[ $CMD == 'init' ]]; then
  terraform "$CMD" \
            -backend-config "$BACKEND_FILE"
else
  # Build the command based on which ever tfvar files are specified for the stack
  TO_RUN="terraform $CMD"
  for TFVAR_FILE in $COMMON_STACK_DATA_FILE \
                    $COMMON_PROJECT_DATA_FILE \
                    $STACK_DATA_FILE
  do
    if [[ -f $TFVAR_FILE ]]; then
      TO_RUN="$TO_RUN -var-file $TFVAR_FILE"
    fi
  done
  eval "$TO_RUN"
fi
