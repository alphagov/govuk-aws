# 19. Centralise MySQL Databases

Date: 2017-08-02

## Status

Accepted

## Context

We currently have a number of MySQL primaries, secondaries and backup machines
managed via Puppet agents that run on the database nodes themselves. While we are currently moving the
data stores to the managed RDS service there are some supporting functions,
such as adding databases and users, that still need to be conducted by a config management
running host.

An additional piece of context is that once the 'lift and shift'
is done we will convert the signon application and database to PostgreSQL.

This ADR is to document where they will run in the future.

## Decision

We discussed three options:

 1. have one admin instance per MySQL database and keep the databases separate
 2. manage the users and databases in terraform itself
 3. centralise the MySQL databases and have one admin machine manage them all

The first option is the simplest, has the most moving parts and the highest expense while also
providing the greatest level of isolation. Due to the low amount of traffic most of the 
MySQL databases receive we decided against this due to cost and the number of
instances it would require.

Option 2 was discounted as we do not want to manage individual aspects of databases and their users
using Terraform providers at this date as we have a large, existing, investment in using puppet 
for these tasks. We would also need a way to pass secrets back and forth between the two code 
bases; a complexity we'd like to defer.

The final option, and the one we've chosen for now, is to have a single instance with a dedicated "db admin"
puppet role that will manage these tasks for all of our databases while also centralising the
databases themselves in to a single RDS instance in order to simplify our connectivity code,
connection strings and secret management. This is also a much cheaper approach.

## Consequences

At this time our traffic is low enough that we can group all the databases together
with some sense of capacity safety. We do acknowledge however that a performance issue with one
of the databases would impact all of the applications.

We're also placing all our database eggs in a single basket. If we lost the RDS cluster
multiple applications would be impacted. This is considered an acceptable risk for our
current experiments.

The changes to our puppet code will all be additions, which reduces the risk of impacting
our currently managed systems.
