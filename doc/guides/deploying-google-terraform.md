## Deploying Google Terraform

Created on: 20 May 2019

This documentation describes how to deploy resources in the Google Cloud
Platform (GCP). At the time of writing, there are very few resources in
GCP that are under the control of terraform. The terraforming of GCP resources
started with the new GOV.UK mirror redesign.

The first step is an initialisation step for new environment where there is
not GCP storage bucker to store the terraform state files. This is run once per
environment.

The second step is to deploy your google-based terraform projects.

### Google Cloud Storage Backend for Terraform

GCP-based terraform projects use a Google Cloud Storage (GCS) bucket per GOV.UK
environment to store the terraform state files rather than a AWS S3 bucket.

This GCS bucket was created by doing the following steps:
1. (if not done already) install the GCP Cloud SDK by following the instructions
   [here](https://cloud.google.com/sdk/)

2. get the GCP service account that you
   want to use to deploy the project. You can use your general
   GDS account to authenticate with the GCP web console. You should then consult
   the GCP documentation about retrieving credentials of a service account
   [here](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#getting_a_service_account_key) and saving it on your local secure machine.

3. add the service account to the gcloud tool by running:
   ```
   gcloud auth activate-service-account --key-file <service_account_credentials_file_path>
   ```
   where `<service_account_credentials_file_path>` is the path where the file
   containing the service account credentials is located.

3. create the GCS bucket:
   ```
   export PROJECT_ID=<gcp_project_id>
   export BUCKET_NAME=govuk-terraform-steppingstone-<govuk_environment>

   gsutil mb -p ${PROJECT_ID} -l eu gs://${BUCKET_NAME}
   ```
   where:
   1. `<gcp_project_id>` is the project ID of the GCP project where you want to deploy
   2. `<govuk_environment>` is the name of the GOV.UK environment, e.g. staging

4. Activate versioning on the bucket by performing:
   ```
   gsutil versioning set on gs://${BUCKET_NAME}
   ```

You can then configure a terraform project to use this backend by:
1. including in the main terraform file of the project, the code snippet:
   ```
   terraform {
     backend          "gcs"            {}
     required_version = "= 0.11.14"
   }
   ```

2. including in the backend terraform file of the project, the following lines:
   ```
   bucket  = "govuk-terraform-steppingstone-<govuk_environment>"
   project = "<gcp_project_id>"
   prefix  = "govuk/<terraform_project_name>"
   ```
   where:
   1. `<govuk_environment>` is the name of the GOV.UK environment, e.g. staging
   2. `<gcp_project_id>` is the project ID of the GCP project where you want to deploy
   3. `<terraform_project_name>` is the name of the terraform project.

### Deployment of GCP-based Terraform Projects

The deployment of GCP-based terraform projects is similar to the AWS ones
except for one difference that the GCP credentials will also have to be provided.

The GCP projects can usually be identified by the prefix being:
`infra-google` or `app-google`.

The steps to deploy a GCP-based terraform project is:
1. get the GCP service account that you
   want to use to deploy the project. You can use your general
   GDS account to authenticate with the GCP web console. You should then consult
   the GCP documentation about retrieving credentials of a service account
   [here](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#getting_a_service_account_key) and saving it on your local secure machine.

2. export the location of the service account credentials by doing:
   ```
   export GOOGLE_APPLICATION_CREDENTIALS=<service_account_credentials_file_path>
   ```
   where `<service_account_credentials_file_path>` is the path where the file
   containing the service account credentials is located.

3. deploy the terraform project as usual. For e.g. if you use aws-vault:
   ```
   aws-vault exec <aws_vault_environment_profile> -- tools/build-terraform-project.sh \
   -c apply -p <terraform_project_to_be_deployed> -d <govuk_aws_data_path> \
   -e <govuk_environment> -s <govuk_stack>
   ```
   where:
   1. `<govuk_environment>` is the name of the GOV.UK environment, e.g. staging
   2. `<aws_vault_environment_profile>` is the name of the aws-vault profile for
      the AWS account of the specific `<govuk_environment>`. The reason why you
      *sometimes* need AWS credentials even if you are deploying GCP-based
      projects is that some projects are dependent on AWS project data. E.g.
      A GCP resource may need some AWS credentials to do some syncing of AWS S3
      buckets
   3. `<govuk_aws_data_path>` is the path where you cloned the *govuk-aws-data*
       git project
   4. `<govuk_stack>` is the stack where you want to deploy the project. e.g.
       govuk

You can see an example of a GCP project [here](../../terraform/projects/infra-google-monitoring)
