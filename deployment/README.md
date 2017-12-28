## Deployment

This contains everything required for running a full deployment of the stack. Since
everything is divided into multiple statefiles, projects have to be deployed in turn.

This is not a replacement for [reading the documentation](https://github.com/alphagov/govuk-aws/blob/master/doc/guides/environment-provisioning.md#build-the-puppet-master).

### Default

To deploy using the `build-terraform-project.sh` tool, use [default deployment configuration](default).

### Terragov

To deploy using [Terragov](https://github.com/surminus/terragov), use [Terragov deployment configuration](terragov).
