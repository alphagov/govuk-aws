# 4. DNS definitions for hosts and services

Date: 2017-07-04

## Status

Pending

## Context

For our current monitoring to work we need Icinga to be able to communicate with hosts and services.

## Decision

Each stack will have an internal, private, zone for internal services such as the puppetmaster. These
will be in the following format:

    $servicename.$stackname.internal

    puppet.perftesting.internal
    monitoring.mystack.internal

## Consequences

TBC
