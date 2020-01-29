#!/usr/bin/env groovy

library("govuk")

REPOSITORY = 'govuk-aws'

node ("terraform") {

  try {
    stage("Checkout") {
      govuk.checkoutFromGitHubWithSSH(REPOSITORY)
    }

    stage("Bundle") {
      govuk.bundleApp()
    }

    stage("Shellcheck") {
      govuk.shellcheck([
        "tools/*.sh",
        "tools/govukcli",
        "terraform/userdata/*",
        "jenkins.sh",
      ])
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

    stage("RSpec") {
      sh "bundle exec rspec spec/validate_resources_spec.rb"
    }

    stage("Resource name lint") {
      sh "bundle exec lib/resource_name_lint.rb"
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
