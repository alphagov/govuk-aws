# 14. DNS infrastructure

Date: 2017-07-14

## Status

Pending

## Context

- All our instances will need to be able to resolve internal infrastructure services, such
us Puppet, Graphite or Logstash
- Some services and application endpoints will need to be exposed to the Internet and
be resolved by public DNS. For instance alerts.integration, deploy.integration, www-origin, etc
- We want to be able to isolate stacks with its own DNS zone for internal testing and to
enable parallel provisioning
- We want to control which stack is running the active version of an application, switch traffic
to a different stack, execute green-blue application deployments, etc.

## Decision

The DNS infrastructure solution look like ![DNS](./0015-dns-infrastructure-img01.jpg?raw=true "DNS Infrastructure")

Each stack has an internal DNS zone and external DNS zone. All Terraform projects in that stack add service
records to the stack zones to expose the service internally and/or externally. These internal and
external DNS zones are managed by a Terraform project. For instance, a 'deana' stack has its own deana.<internalrootdomain>
zone and deana.<externalrootdomain> zone. Puppet and Icinga services in this stack will add a puppet.deana.<internalrootdomain>
record and alerts.deana.<externalrootdomain> record to the stack DNSs

There is an internal and external DNS zone to manage the root domain that delegates the stack entries to
each stack zone. This root domain DNS zone will also select the active version of each application. For
instance, machines  are using the Puppet service in puppet.<internalrootdomain> that is a 
CNAME of puppet.deana.<internalrootdomain>. At some point, a new Puppet stack is provisioned to test a new version,
and when it has been tested we switch the CNAME to the new stack, so puppet.<internalrootdomain>
resolves to puppet.newstack.<internalrootdomain>. The same approach can be used for application stacks, so
green-blue deployments can be implemented in this infrastructure.

The root domain DNS records don't need to be managed by Terraform. We can implement lightweight scripts inserted
in the Deployment process to switch active versions between stacks.

## Consequences

Initially we need to manage the entries in the root domains manually.
