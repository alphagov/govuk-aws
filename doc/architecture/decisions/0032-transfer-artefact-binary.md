# 32. transfer artefact binary

Date: 2018-03-26

## Status

Accepted

## Context

We create binary artifacts for applications when we execute the **Deploy_App**
Jenkins job. The binary file (artifact) gets stored in an AWS S3 bucket
(For example **govuk-integration-artefact**). We need the binary file to deploy
the application to the next environment. For example, we will use the binary
file from **Integration** to deploy the application in the **Staging**
environment.

## Decision

We decided to use a mechanism that is located outside the environments involved
and pass the contents to the correct locations when the package becomes
available.

![Transfer Mechanism](./0032-transfer-artefact-binary-img01.png?raw=true "Transfer Mechanism")

### Example

We will use the **Integration** and **Staging** environments as examples.

1. We execute the **Deploy_Apps -> router** Jenkins job in the Integration environment.
2. A binary file is created in the **govuk-integration-artefact** AWS S3 bucket.
3. We have an AWS SNS Topic called **govuk-integration-artefact**.
4. We have an AWS S3 **govuk-integration-artefact** bucket event notification. This event sends a notification to the AWS SNS Topic when an **ObjectCreate** event is triggered.

5. The **Staging** environment has an AWS S3 bucket called **govuk-staging-artefact**.
6. We have an AWS SNS Subscription that subscribes to the **govuk-integration-artefact** AWS SNS Topic. This subscription will enable Staging to know when a new object gets created in the **govuk-integration-artefact** AWS S3 bucket.
7. We have an AWS Lambda function called **govuk-staging-artefact**. This function copies objects from the destination bucket to the target bucket. The trigger for the function is the AWS SNS Subscription.

## Consequences

This process requires a new object to be created at the source for the mechanism to be triggered and executed. This means that when we are initially building an environment, we will have to execute the relevant **Deploy_Apps** jobs at the source environment after the target environment is built, to get the artifacts.
