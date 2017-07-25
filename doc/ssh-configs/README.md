## SSH Configs

Add the configs found in this directory to ~/.ssh/config to access the named
AWS stack.

## govuk-ssh

`govuk-ssh` is a wrapper script which uses a script found on jumpboxes to enable
access to machines in our environments without long lists of SSH config.

## Install

Copy the script to `/usr/local/bin/govuk-ssh` and make executable.

## Usage

To jump to a specific Puppet role in a stack in an environment:

`govuk-ssh integration delana jenkins`

If more than one machine exists under a specific role it will select the first
IP returned by the API.

If you want to jump to a specific machine, use the IP:

`govuk-ssh integration delana 1.2.3.4`
