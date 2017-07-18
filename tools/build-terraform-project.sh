#!/bin/bash
#
# This is a wrapper for terraform to make running projects easier.
# It takes three arguments: the command (e.g. "init" or "apply"), the project
# name (e.g. "infra-networking" or "app-jumpbox") and the stack to run it in.
#

set -e

function usage() {
  echo -e "usage: $0 [CMD] [ENVIRONMENT] [STACKNAME] [PROJECT]\n"
  echo -e 'CMD\t\t The Terraform command to run, eg "init", "plan" or "apply".'
  echo -e 'ENVIRONMENT\t The environment to deploy to eg "aws-integration".'
  echo -e 'STACKNAME\t Specify the name of the ".tfvars" and ".backend" files.'
  echo -e 'PROJECT\t\t Specify which project to create, eg "infra-networking".'
}

function log_error() {
  echo -e "ERROR: $*\n"
  HELP=1
}

# Get the arguments
CMD=$1
ENVIRONMENT=$2
STACKNAME=$3
PROJECT=$4

# Set up our locations
TERRAFORM_DIR='./terraform'

PROJECT_DIR="${TERRAFORM_DIR}/projects/${PROJECT}"
BACKEND_FILE="${ENVIRONMENT}.${STACKNAME}.backend"

# We're going to CD into $PROJECT_DIR so make paths relative to that.
DATA_DIR="../../data"

COMMON_DATA_DIR="${DATA_DIR}/common/${ENVIRONMENT}"

COMMON_DATA="${COMMON_DATA_DIR}/common.tfvars"
STACK_COMMON_DATA="${COMMON_DATA_DIR}/${STACKNAME}.tfvars"

PROJECT_DATA_DIR="${DATA_DIR}/${PROJECT}/${ENVIRONMENT}"

COMMON_PROJECT_DATA="${PROJECT_DATA_DIR}/common.tfvars"
STACK_PROJECT_DATA="${PROJECT_DATA_DIR}/${STACKNAME}.tfvars"
SECRET_PROJECT_DATA="${PROJECT_DATA_DIR}/${STACKNAME}_secrets.tfvars"

if [[ $CMD = "-h" ]]; then
  usage
  exit
fi

# Check we have all the arguments we need
if [[ -z $CMD ]];  then
  log_error 'Specify the Terraform command to run, eg "init", "plan" or "apply".'

fi

if [[ -z $PROJECT ]]; then
  log_error 'Specify which project to create, eg "infra-networking".'

elif [[ ! -d $PROJECT_DIR ]]; then
  log_error "Could not find $PROJECT directory: $PROJECT_DIR"

fi

if [[ -z $STACKNAME ]]; then
  log_error 'Specify the stackname (prefix of the ".tfvars" and ".backend" files).'

# We check for these files relative to $PROJECT_DIR as we'll later `cd` to them.
elif [[ $CMD == "init" ]] && [[ ! -f $PROJECT_DIR/$BACKEND_FILE ]]; then
  log_error "Could not find backend file '$PROJECT_DIR/$BACKEND_FILE'"

# e.g. terraform/projects/app-foo/../../data/app-foo/
elif [[ ! -f $PROJECT_DIR/$STACK_COMMON_DATA ]] && \
     [[ ! -f $PROJECT_DIR/$STACK_PROJECT_DATA ]] && \
     [[ ! -f $PROJECT_DIR/$SECRET_PROJECT_DATA ]]; then
  log_error 'Could not find any tfvar files. Looked for:\n' \
            "\t$PROJECT_DIR/$STACK_COMMON_DATA \n " \
            "\t$PROJECT_DIR/$STACK_PROJECT_DATA \n " \
            "\t$PROJECT_DIR/$SECRET_PROJECT_DATA"
fi

# If there's been an error print the usage & exit
if [[ $HELP == "1" ]]; then
  usage
  exit 1
fi

# Run everything from the appropriate project
cd "$PROJECT_DIR"

# Actually run the command
if [[ $CMD == 'init' ]]; then
  terraform "$CMD" \
            -backend-config "$BACKEND_FILE"
else
  # Build the command to run
  TO_RUN="terraform $CMD"
  # Append which ever tfvar files exist
  for TFVAR_FILE in "$COMMON_DATA" \
                    "$STACK_COMMON_DATA" \
                    "$COMMON_PROJECT_DATA" \
                    "$STACK_PROJECT_DATA" \
                    "$SECRET_PROJECT_DATA"
  do
    if [[ -f $TFVAR_FILE ]]; then
      TO_RUN="$TO_RUN -var-file $TFVAR_FILE"
    fi
  done

  eval "$TO_RUN"
fi
