# 6. Puppet architecture

Date: 2017-07-04

## Status

Pending

## Context

For our initial iteration we should discuss whether we use a Puppetmaster architecture,
or use a masterless Puppet approach.

Using the former approach, we would have to take the following into account:

 - We would set up a Puppetmaster for the rest of the provisioned instances to connect to
 - We would deploy new Puppet code to this machine only
 - It matches our current architecture and approach
 - We would need to take into account certificate management
 - Each machine would "check in" to the Puppetmaster every 30 minutes, ensuring
 a consistent state

If we used a masterless approach:

 - We would need to deploy Puppet code and secrets to each instance that we provision
 - We would run Puppet only when we deploy new code
 - It differs from our current approach
 - We would not have to manage a Puppetmaster which means no single point of failure

## Decision

Use a Puppetmaster to not diverge from current architecture in the initial iteration.

## Consequences

We may suffer from having to manage two Puppetmasters while we run in
two environments.

There is additional work around the management of a Puppetmaster.

However, this matches our current working architecture so it means that we're more
in line of doing a straight "lift and shift". In theory deployments would be more
straight forward to manage as we would not have to create a new deployment process,
instead we could amend the current deployment process.
