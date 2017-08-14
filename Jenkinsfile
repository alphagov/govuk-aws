#!/usr/bin/env groovy

REPOSITORY = 'govuk-aws'

node ("terraform") {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  try {
    stage("Checkout") {
      govuk.checkoutFromGitHubWithSSH(REPOSITORY)
    }

    stage("ADR check") {
      sh "tools/adr-check.sh"
    }

    stage("Terraform lint") {
      sh "find . -name '*.tf' |xargs tools/terraform-format.sh"
    }

    stage("JSON check") {
      sh "find . -name '*.json' |xargs tools/json-check.sh"
    }

    if (env.BRANCH_NAME == 'master'){
      stage("Push release tag") {
        echo 'Pushing tag'
        govuk.pushTag(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
      }
    }

  } catch (e) {
    currentBuild.result = "FAILED"
    step([$class: 'Mailer',
          notifyEveryUnstableBuild: true,
          recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
          sendToIndividuals: true])
    throw e
  }

  // Wipe the workspace
  deleteDir()
}

