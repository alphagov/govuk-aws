# 7. Puppet certificate management

Date: 2017-07-04

## Status

Accepted

## Context

When machines connect to a Puppetmaster, they require a signed certificate to be
present to allow interaction.

If we lose a Puppetmaster (or it is recreated by an Auto Scaling Group) then we 
would have to re-sign all the certificates to allow all machines in the
environment to run Puppet again (ref: https://docs.puppet.com/puppet/3.8/ssl_regenerate_certificates.html).

This would involve manual intervention to allow machines to connect again
and we would be unable to deploy new Puppet code during this period.

Ideally we should back up our signed certificates, and a new machine would
be able to restore them when it is recreated.

## Decision

We will defer this until a later date while we're testing this with Integration
to concentrate on getting the stack up and running and accept the loss of certicates.

At a later date we will re-visit this approach and implement a suitable solution.

## Consequences

If we lose our Puppetmaster while we are not backing up our certificates it
may delay us while we have to regenerate certificates.

We will be able to focus on bringing up the environment rather than working on a
solution that is not currently present in our Puppet code.
