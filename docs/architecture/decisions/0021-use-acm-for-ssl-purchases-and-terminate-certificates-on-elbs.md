# 21. Use ACM for SSL purchases and terminate certificates on ELBs

Date: 2017-08-14

## Status

Accepted

## Context

Traditionally to manage our SSL certificates, we did the following:

 - Purchased SSL certificates from a third party company, and did manual renewals
 - Set up monitoring so we were aware when a certificate needed to be renewed
 - Terminated SSL using nginx on the frontend_lb and backend_lb machines

We have looked into using Amazon Certificate Manager (ACM) to purchase and manage
our SSL certificates, and using Elastic Load Balancers (ELBs) to terminate the
SSL in front of the instances.

## Decision

We have decided to use ACM to manage our SSL certificates, and terminate SSL on
the ELBs.

This gives us the following advantages:

 - Automatic renewal and notifications related to the SSL certificates we purchase
 through ACM
 - Multi-domain certificates; this helps us manage several stacks within an environment
 eg *.blue.integration.govuk.digital, *.green.integration.govuk.digital
 - Terminate SSL on ELBs means the deployment is managed through Terraform
 - We reference the certificate by an ARN ID, rather than having the SSL private key
 and certificate be present in encrypted hieradata

## Consequences

Technically this may be considered vendor lock-in, but the advantages significantly
outweigh the cost.

We can only manually create certificates in ACM so are unable to automate this process,
but we accept the time cost of doing this step.
