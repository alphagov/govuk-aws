## Connecting to the environment

Since we do not have control of the hostnames in AWS, it is no longer possible to
use the SSH configuration that was traditionally used in GOV.UK.

There are two ways to get to instances you wish to work on.

## Manually use lookup instance hostnames

SSH to the jumpbox:

`ssh -A jumpbox.<stackname>.<environment>.govuk.digital`

Find one of the instances you need:

`govuk_node_list -c <node class>`

SSH to the hostname:

`ssh some-host-name.eu-west-1.compute.internal`

## govuk-ssh

`govuk-ssh` is a wrapper script which uses a script found on jumpboxes to enable
access to machines in our environments without long lists of SSH config.

### Install

The script is [located here](tools/govuk-ssh).

Copy the script to `/usr/local/bin/govuk-ssh` and make executable.

### Usage

To jump to a specific Puppet role in a stack in an environment:

`govuk-ssh <environment> <stackname> <node class>`

If more than one machine exists under a specific role it will select the first
IP returned by the API.

If you want to jump to a specific machine, use the IP:

`govuk-ssh integration blue 1.2.3.4`
