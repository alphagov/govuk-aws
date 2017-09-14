# 24. AMI Lookups

Date: 2017-08-29

## Status

Accepted

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

The other alternative is to specify a specific image name. This has the benefit that
we know exactly which version we deploy and it cannot change without our intervention.

## Decision

We override the `instance_ami_filter_name` parameter of the `node_group` module in all
the projects. In the data directory, there is a common variable that sets the default
value of the parameter for an environment. This can be customised per project in the
project tfvars file.

## Consequences

Moving away from the dynamic AMI lookup means we might deploy auto scaling groups
with an older version of the AMI that could have more security issues present. We'd
work around this in the same way we do our other environments; by using the overnight
security patching we deploy via puppet.
