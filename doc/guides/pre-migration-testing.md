## Pre Migration Testing

Some guidance to help enable testing before the migration.

### Updating your hosts file

Before DNS has been migrated we need to be able to test the top level service domain.

Add the associated host into your hosts file:

`dig +short www-origin.integration.govuk.digital |tail -n1 |sed 's/$/ www-origin.integration.publishing.service.gov.uk/g' | sudo tee -a /etc/hosts`

To remove:

`sudo sed -i .bak /www-origin.integration.publishing.service.gov.uk/d /etc/hosts`
