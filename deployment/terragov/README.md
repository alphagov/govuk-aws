## Terragov deployment

You must have Terragov 0.3.1.1 or higher:

`gem install terragov`

### Base

Deploy the base infrastructure:

`terragov deploy --command <plan or apply> --file deployment.yaml --group base --config-file integration.yaml`

### Deploy Puppetmaster and Jenkins

Follow the [environment provisioning guide](https://github.com/alphagov/govuk-aws/blob/master/doc/guides/environment-provisioning.md#build-the-puppet-master).

These projects require some special intervention if you are deploying for the first time.

### Deploy everything else

Check [`deployment.yaml`](deployment.yaml) to see how the projects are split up.

`terragov deploy --command <plan or apply> --file deployment.yaml --config-file integration.yaml -s <stackname> --group <group>`
