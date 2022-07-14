#!/bin/bash
#
# This is a wrapper for terraform to make running projects easier.
# It takes three arguments: the command (e.g. "init" or "apply"), the project
# name (e.g. "infra-networking" or "app-jumpbox") and the stack to run it in.
#

set -e

while getopts "c:d:e:p:s:h" option
do
  case $option in
    c ) CMD=$OPTARG ;;
    d ) DATA_DIR=$OPTARG ;;
    e ) ENVIRONMENT=$OPTARG ;;
    p ) PROJECT=$OPTARG ;;
    s ) STACKNAME=$OPTARG ;;
    h|* ) HELP=1 ;;
  esac
done

function usage() {
  cat <<EOM
usage: $0 -c -e -p -s

     -c   The Terraform command (CMD) to run, eg "init", "plan" or "apply".
     -d   The root of the data directory (DATA_DIR) to take .tfvars files from.
     -e   The ENVIRONMENT to deploy to eg "aws-integration".
     -s   Specify the STACKNAME of the ".tfvars" and ".backend" files.
     -p   Specify which PROJECT to create, eg "infra-networking".
     -h   Display this message.

Any remaining arguments are passed to Terraform
e.g. $0 -c plan -e foo -p bar -s baz -- -var further=override
     will pass "-var further=override" to terraform

Tip: these arguments can be passed by environment variable as well
     using the upper case version of their name.
EOM
}

function log_error() {
  echo -e "ERROR: $*\n"
  HELP=1
}

if [[ $HELP = '1' ]]; then
  usage
  exit
fi

# un-shift all the parsed arguments
shift "$((OPTIND - 1))"

# Set up our locations
TERRAFORM_DIR='./terraform'

PROJECT_DIR="${TERRAFORM_DIR}/projects/${PROJECT}"
BACKEND_FILE="${ENVIRONMENT}.${STACKNAME}.backend"

# We're going to CD into $PROJECT_DIR so make paths relative to that.
echo "data dir is " $DATA_DIR
DATA_DIR="../../../${DATA_DIR}"

COMMON_DATA_DIR="${DATA_DIR}/common/${ENVIRONMENT}"

COMMON_DATA="${COMMON_DATA_DIR}/common.tfvars"
SECRET_COMMON_DATA="${COMMON_DATA_DIR}/common.secret.tfvars"
STACK_COMMON_DATA="${COMMON_DATA_DIR}/${STACKNAME}.tfvars"

PROJECT_DATA_DIR="${DATA_DIR}/${PROJECT}/${ENVIRONMENT}"

COMMON_PROJECT_DATA="${PROJECT_DATA_DIR}/common.tfvars"
SECRET_COMMON_PROJECT_DATA="${PROJECT_DATA_DIR}/common.secret.tfvars"
STACK_PROJECT_DATA="${PROJECT_DATA_DIR}/${STACKNAME}.tfvars"
SECRET_PROJECT_DATA="${PROJECT_DATA_DIR}/${STACKNAME}.secret.tfvars"

if [[ -z $(command -v terraform) ]]; then
  log_error 'Terraform not found, please make sure it is installed.'
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
     [[ ! -f $PROJECT_DIR/$SECRET_PROJECT_DATA ]] && \
     [[ ! -f $PROJECT_DIR/$COMMON_DATA ]]  && \
     [[ ! -f $PROJECT_DIR/$SECRET_COMMON_PROJECT_DATA ]]  && \
     [[ ! -f $PROJECT_DIR/$COMMON_PROJECT_DATA ]]; then
  log_error 'Could not find any tfvar files. Looked for:\n' \
            "\t$PROJECT_DIR/$STACK_COMMON_DATA \n " \
            "\t$PROJECT_DIR/$STACK_PROJECT_DATA \n " \
            "\t$PROJECT_DIR/$SECRET_PROJECT_DATA \n " \
            "\t$PROJECT_DIR/$COMMON_DATA\n " \
            "\t$PROJECT_DIR/$SECRET_COMMON_PROJECT_DATA\n " \
            "\t$PROJECT_DIR/$COMMON_PROJECT_DATA"
fi

# If there's been an error print the usage & exit
if [[ $HELP == "1" ]]; then
  usage
  exit 1
fi

# Run everything from the appropriate project
cd "$PROJECT_DIR"



# Actually run the command
function init() {
  if [[ ! -f $BACKEND_FILE ]]; then
    echo "Could not find backend file for $STACKNAME stack."
    echo "Possible stacks to deploy in $ENVIRONMENT for $PROJECT are: "
    find . -name "${ENVIRONMENT}.*.backend" |cut -d "." -f3
    exit 1
  fi
  rm -rf .terraform && \
  rm -rf terraform.tfstate.backup && \
  terraform init \
            -backend-config "$BACKEND_FILE"
}

# Build the command to run
TO_RUN="init && terraform $CMD"
# Append which ever tfvar files exist
for TFVAR_FILE in "$COMMON_DATA" \
                  "$SECRET_COMMON_DATA" \
                  "$STACK_COMMON_DATA" \
                  "$COMMON_PROJECT_DATA" \
                  "$SECRET_COMMON_PROJECT_DATA" \
                  "$STACK_PROJECT_DATA" \
                  "$SECRET_PROJECT_DATA"
do
  if [[ -f $TFVAR_FILE ]] &&
     {
      [[ "$TFVAR_FILE" == "$SECRET_COMMON_DATA" ]] ||
      [[ "$TFVAR_FILE" == "$SECRET_PROJECT_DATA" ]] ||
      [[ "$TFVAR_FILE" == "$SECRET_COMMON_PROJECT_DATA" ]]
     } ; then
    TO_RUN="$TO_RUN -var-file <(sops -d $TFVAR_FILE)"
  elif [[ -f $TFVAR_FILE ]]; then
    TO_RUN="$TO_RUN -var-file $TFVAR_FILE"
  fi
done

eval "$TO_RUN $*"
