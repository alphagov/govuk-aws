# 15. DNS infrastructure

Date: 2017-07-20

## Status

Accepted

## Context

- All our instances will need to be able to resolve internal infrastructure services, such
us Puppet, Graphite or Logstash
- Some services and application endpoints will need to be exposed to the Internet and
be resolved by public DNS. For instance alerts.integration, deploy.integration, www-origin, etc
- We want to be able to isolate stacks with its own DNS domain for internal testing and to
enable parallel provisioning
- We want to control which stack is running the active version of an application, switch traffic
to a different stack, execute green-blue application deployments, etc.

## Decision

The DNS infrastructure solution look like ![DNS](./0015-dns-infrastructure-img01.jpg?raw=true "DNS Infrastructure")

#### Stack domains

Each stack has an internal and external DNS domain. All Terraform projects in that stack add records
to Route53 zones to expose the service internally and/or externally.

For instance, a 'green' stack has its own `green.<internalrootdomain>` and `green.<externalrootdomain>`
domain. Puppet and Icinga services in this stack will add `puppet.green.<internalrootdomain>` and
`alerts.green.<externalrootdomain>` to Route53.

### Root domain service records

All services will also need an entry with the root domain that points to a stack record. This entry
can be updated to select the active version of each service.

For instance, machines are using the Puppet service `puppet.<internalrootdomain>` that is a CNAME
of `puppet.green.<internalrootdomain>`. At some point, a new Puppet stack 'blue' is provisioned to
test a new version, and when it has been tested we switch the CNAME to the new stack, so
`puppet.<internalrootdomain>` resolves to `puppet.blue.<internalrootdomain>`.

The same approach can be used for application stacks, so green-blue deployments can be implemented in
this infrastructure.

The root domain service records don't need to be managed by Terraform. We can implement lightweight
scripts inserted in the Deployment process to switch active versions between stacks.

#### External Route53 zones

There is a public (external) Route53 zone to manage the external root domain. Each stack has also its own
external Route53 zone where we delegate the stack subdomain.

For instance, if we are setting up a new environment with a public root domain `test.govuk.digital`,
and create a new stack 'green', we'll have a zone for `test.govuk.digital` and a zone for the stack
subdomain `green.test.govuk.digital`, that stores the stack records.

#### Internal Route53 zones

For internal domains we can't replicate the external configuration because it's not possible to do DNS
delegation with internal zones in the same VPC when the domains overlap.

For instance, for the previous scenario we will have an internal zone for the root domain
`test.govuk-internal.digital`, but we can't create and delegate a subdomain for a zone
`green.test.govuk-internal.digital` in the same VPC because it overlaps the root domain.

In this case, for internal domains we can only have a single zone, but we'll still keep the same
domain schema and each stack will generate records appending the stack subdomain.

![Example](./0015-dns-infrastructure-img02.jpg?raw=true "DNS Infrastructure")

## Consequences

Initially we need to manage the entries in the root domains manually.
