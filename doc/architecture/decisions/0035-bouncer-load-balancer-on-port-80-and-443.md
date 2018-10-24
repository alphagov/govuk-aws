# 3. Bouncer Public Load Balancer Configuration

Date: 2018-10-22

## Status

Pending

## Context

Currently, Bouncer public load balancer accepts HTTPS request on port 443 and
redirects the traffic to port 80 on the Bouncer servers.

There are a primary as well as a secondary SSL/TLS certificate attached to this HTTPS
listener of the load balancer.

## Decision

The configuration of the Bouncer public load balancer was modified to:
1. Add a second listener to the load balancer so that HTTP request on port 80 can be
   served by the Bouncer servers. This functionality exists in the Carrenza environment
   and we aim to replicate this feature to maintain feature parity.

## Consequences

In order to implement the decision above, the following code changes were done:
1. the terraform [plan](../../../terraform/projects/infra-public-services/main.tf)
was changed so that the input to the `aws/lb` terraform module specifies a second
listener `"HTTP:80"   = "HTTP:80"` in the listener map for the Bouncer public
load balancer.

2. the `aws/lb` terraform module [here](../../../terraform/modules/aws/lb/main.tf) had
to be fixed so that SSL/TLS certificates and SSL policies are not added to a HTTP
listener.
