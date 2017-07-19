# 16. internal DNS zones

Date: 2017-07-19

## Status

Accepted

## Context

We have a number of internal services that need to have
internal only service records. This allows clients to connect
within their own environment or stack without needing a fully
qualified domain name.

These records should not be visible outside the local environment or stack.

## Decision

We've bought a domain name that will not be connected to the rest of the public
DNS system. This will be used by our internal services.

This domain will *not* have DNS records added to it.

## Consequences

We have a domain that we pay for and don't use.

If the registration ever expires, and we've incorrectly defined our search paths,
someone could register it and influence our services. This risk is however
present in all the domains we use.

This is also the approach taken by some of our sister teams.
