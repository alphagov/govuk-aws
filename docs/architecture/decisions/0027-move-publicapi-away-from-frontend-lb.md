# 27. Move PublicAPI away from frontend-lb

Date: 2017-09-04

## Status

Accepted

## Context

Traffic flows for frontend applications in the following way:

![Frontend traffic flow](./0027-move-publicapi-away-from-frontend-lb-img01.jpg?raw=true "Frontend traffic flow")

Most frontend applications can go straight from the cache instances to the application instances, bypassing frontend-lb. They do this by creating a DNS entry for each application service ELB, and setting the appropriate upstream DNS entry for the nginx configuration on the cache machines.

The exception to this rule is the "publicapi" application ([reference](https://github.com/alphagov/govuk-puppet/blob/34c587b76abee63d0c84b9f67212ac2f1c65ba2e/modules/govuk/manifests/apps/publicapi.pp)).

This is a set of nginx configuration that sits on frontend-lb, and forwards specific paths to applications upstream.

Router on the cache instances forwards all traffic bound for `/api` to frontend-lb, and then publicapi handles the forwarding from there.

The configuration for the paths is [relatively simple](https://github.com/alphagov/govuk-puppet/blob/34c587b76abee63d0c84b9f67212ac2f1c65ba2e/modules/govuk/templates/publicapi_nginx_extra_config.erb).

## Decision

Move publicapi application to either the cache instances themselves, or replace the configuration with an Application Load Balancer.

## Consequences

The frontend-lb will be able to be removed from the stack.
