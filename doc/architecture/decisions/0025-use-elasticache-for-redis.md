# 25. Use Elasticache for Redis

Date: 2017-09-04

## Status

Accepted

## Context

Traditionally we provisioned our own redis machines in a non-clustered state.

AWS provide Elasticache which has a Redis engine, and can be configured to be clustered.

We should consider provisioning Elasticache to replace our provisioned Redis instances.

## Decision

We are using Elasticache instead of provisioning our own Redis instances.

## Consequences

We have less Puppet code to manage. There is no risk of lock-in because the client side
behaviour is not changed.

There are some [restricted commands](http://docs.aws.amazon.com/AmazonElastiCache/latest/UserGuide/ClientConfig.RestrictedCommands.html) in Elasticache which may impact our management of it.
