## Deploying Terraform

To deploy infrastructure changes using Terraform, you have a choice of two tools
detailed below.

### build-terraform-project.sh

Default tool written in Bash.

It takes several command line arguments which can also be set using environment
variables.

Run `tools/build-terraform-project.sh -h` for details.

**this must be run from the root of this repo.**

### Terragov

Alternative tool written in Ruby.

Install: `gem install terragov`

If you are working on the same environment, stack or project for a long period,
commands can be simplified with a config file:

```
$ cat ~/.terragov.yml
---
default:
  environment: 'integration'
  stack: 'blue'
  repo_dir: '~/govuk/govuk-aws'
  data_dir: '~/govuk/govuk-aws-data/data'

infra-security-groups:
  stack: 'govuk'
```

Add the config file location to your shell:

Bash:
`echo "export TERRAGOV_CONFIG_FILE=~/.terragov.yml" >> ~/.bashrc`

Zsh:
`echo "export TERRAGOV_CONFIG_FILE=~/.terragov.yml" >> ~/.zshrc`

This tool can be run from within any directory.

Further information can be found [here](https://github.com/surminus/terragov).
