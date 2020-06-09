# 29. Combine api-redis into backend-redis

Date: 2017-09-14

## Status

Accepted

## Context

We currently have 3 Redis instances that we run in Elasticache:

 - backend-redis
 - logs-redis
 - api-redis

Most applications use backend-redis, the logging cluster uses logs-redis (which should
soon be replaced), and Rummager uses api-redis.

This was traditionally the case because Rummager lived in a different vDC to redis-1/redis-2,
but this is no longer a concern in AWS.

## Decision

Update Rummager configuration so it uses backend-redis, and remove api-redis.

## Consequences

Everything relying on a single redis instance could potentially have impact if there is
an issue with that Elasticache instance.

We will save money on not running multiple Elasticache instances.
