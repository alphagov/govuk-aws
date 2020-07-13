#!/bin/bash

set -e

function usage(){
  echo -e "usage: $0 [ENVIRONMENT] [REGION] [STACKNAME] [PROJECT/-a]\n"
  echo -e 'ENVIRONMENT\t Short name of the environment being used.'
  echo -e 'REGION\t The AWS region being used.'
  echo -e 'STACKNAME\t Name of the stack to create a backend for.'
  echo -e 'PROJECT\t\t Which project to create a backend for.'
  echo -e '-a\t\t Create backends for all projects, cannot be used with PROJECT.'
}

HELP=0

ENVIRONMENT=$1
REGION=$2
STACKNAME=$3
PROJECT=$4

PROJECTS_DIR='./terraform/projects'

BACKEND_FILENAME="${ENVIRONMENT}.${STACKNAME}.backend"

if [[ $ENVIRONMENT = "-h" ]]; then
  usage
  exit
fi

function log_error() {
  echo -e "ERROR: $*\n"
  HELP=1
}

if [[ -z $ENVIRONMENT ]]; then
  log_error 'You must specify an environment.'
fi

if [[ -z $REGION ]]; then
  log_error 'You must specify an AWS region.'
fi

if [[ -z $STACKNAME ]]; then
  log_error 'You must specify a stackname.'
fi

if [[ -z $PROJECT ]]; then
  log_error 'You must specify a project or "-a".'
fi

if [[ $HELP = "1" ]]; then
  usage
  exit 1
fi

function create_backend(){
  local PROJECT_NAME=$1
  local BACKEND_DIR="${PROJECTS_DIR}/${PROJECT_NAME}"
  local BUCKET_NAME="govuk-terraform-steppingstone-${ENVIRONMENT}"

  if [[ ! -d $BACKEND_DIR ]]; then
    log_error "Could not find project directory: $BACKEND_DIR"
    exit 1
  fi

  local BACKEND_FILE="${BACKEND_DIR}/${BACKEND_FILENAME}"
  cat <<EOF > "$BACKEND_FILE"
bucket  = "${BUCKET_NAME}"
key     = "${STACKNAME}/${PROJECT_NAME}.tfstate"
encrypt = true
region  = "${REGION}"
EOF
  echo "Created backend file: $BACKEND_FILE"
}

if [[ $PROJECT = "-a" ]]; then
  for PROJ in $(find ${PROJECTS_DIR}/infra-* -maxdepth 0 | cut -d '/' -f4); do
    create_backend "$PROJ"
  done
  for PROJ in $(find ${PROJECTS_DIR}/app-* -maxdepth 0 | cut -d '/' -f4); do
    create_backend "$PROJ"
  done
else
  create_backend "$PROJECT"
fi
