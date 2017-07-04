# 11. Migration Strategy

Date: 2017-07-04

## Status

Accepted

## Context

Two strategies were considered for the "lift and shift" aspect of this work. This is to clarify what those two options were and what was considered in the process of making the decision.

1) Migrate an environment to AWS step-by-step in groups of applications at a time - eg. frontends, then backends or even finer groupings, and building the infrastructure as we go.

2) Provision and configure the entire environment, deploy all applications, restore all databases and other data and then switchover to using the new environment in one go - a small maintenance window is necessary to sync data and switch DNS.

## Decision

The second option - all in one go - was decided because:

a) The change is atomic. Either the environment is live in AWS or it's live in the current environment. This is much easier to manage than having elements of the environment in two places and having two sets of monitoring, Puppet masters, metrics etc.

b) Related to a) - unless there is a very strict migration plan with dates and deadlines, we risk running on two platforms with all the extra work that creates for a long period of time if we don't migrate atomically.

c) Higher flexibility to test tearing down and bringing up stacks in their entirety without affecting a live service. That is, no test stack will require any infrastructure from the existing hosting platform to support it.

d) This method much more accurately mirrors a DR situation and so this migration to AWS also doubles as DR preparation and rehearsal as complete environments are built, tested, removed and built again continuously over the course of the task.

## Consequences

* Less planning is required as we can entirely concentrate on getting the core applications running on Integration without risk of anything affecting a live service

* There will need to be a maintenance window for the actual switchover and out-of-hours work to action this.

* During the testing phase, there will be an increase in costs as the full stack is maintained on the current platform as well as a full stack in AWS.
