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

### Completion

The script comes with tab completion to make it easier to work with.

#### Bash and Homebrew

`brew install bash-completion`

Follow the instructions after install to ensure completions work, and link the file
to the completion directory:

`ln -s ~/govuk/govuk-aws/tools/govukcli.completion /usr/local/etc/bash_completion/govukcli`

#### Zsh

There are no Zsh completions for the script, but it does load bash completion compatability
for Zsh.

The easiest way to install is to load it in `~/.zshrc`:

`echo "source ~/govuk/govuk-aws/tools/govukcli.completion" >> ~/.zshrc`
