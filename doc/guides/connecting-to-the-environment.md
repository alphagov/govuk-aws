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

## govukcli tool

The `govukcli` is a script which can help you login to the environment.

### Install

```
wget https://raw.githubusercontent.com/alphagov/govuk-aws/master/tools/govukcli
chmod +x govukcli
mv govukcli /usr/local/bin/
```

### Usage

First, ensure you have a context set. These should match environment names:

`govukcli set-context integration`

To jump to a specific Puppet role to the environment as specified by the context:

`govukcli ssh <node class>`

To view current context:

`govukcli get-context`

To list available contexts:

`govukcli list-contexts`
