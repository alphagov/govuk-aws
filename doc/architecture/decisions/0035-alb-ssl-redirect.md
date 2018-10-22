# 3. Terraform Bouncer ALB redirect 80 to internal 80
 
Date: 2018-10-22
 
## Status
 
Pending
 
## Context

This ADR is part of the GOV.UK migration. The aim is to send HTTP requests that come from bouncer to the correct internal resource. The redirect should send requests to internal port 80. We want to service bouncer request on port 80.

The current certificate that is created has got the following: *.govuk.digital. Bouncer is currently not HTTPS aware.

The project path is the following: govuk-aws/terraform/projects/infra-public-services
The resource module that cause problems is the following: bouncer_public_lb

We have added the following to enable redirects from both port.

    listener_action = {
    "HTTP:80"   = "HTTP:80"
    "HTTPS:443" = "HTTP:80"
    }

The module would try to create two certifcates to place on to both ports. We needed a way to make sure that only one certificate was created and added to the correct endpoint of the ALB. In this instance the correct endpoint is port 443. Port 80 should be left intact with no certificate serving HTTP.

## Decision



## Consequences
