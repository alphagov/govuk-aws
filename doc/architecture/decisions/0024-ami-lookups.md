# 24. AMI Lookups

Date: 2017-08-29

## Status

Pending

## Context

All of our launch configs require that an Amazon Machine Image (AMI) be
specified. How the AMI ID is specified is the point of debate.

Currently we use the `aws_ami` data source to determine the newest AMI ID
published by Ubuntu within a major version and use that in our launch
configurations. This ensures we're always using newest version of Ubuntu
when we spin up a new set of machines. On the downside, as this can change
without our intervention, our terraform runs sometimes want to change more than
we would expect:

```
  image_id: "ami-2944as50" => "ami-10c9asa9" (forces new resource)
```

In some cases _this is fine_ but due to the legacy nature of our deployments
it causes issues with machines that need a number of manual deployment steps
applied to them. Examples of these include the app servers and the puppet
master.

The other alternative is to specify a literal AMI ID. This has the benefit that
we know exactly which version we deploy and it cannot change without our intervention.

The second point of discussion is how to implement this. We could use a `coalesce`
to allow the specification of a literal AMI in some places and fall back to the
newest Ubuntu AMI when no explicit value is provided. The main alternative is to remove
all the lookup code and 'just' have a hard coded value passed in as a config option.

## Decision

TBD

## Consequences

Moving away from the dynamic AMI lookup means we might deploy auto scaling groups
with an older version of the AMI that could have more security issues present. We'd
work around this in the same way we do our other environments; by using the overnight
security patching we deploy via puppet.
