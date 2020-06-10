## Pre Migration Testing

Some guidance to help enable testing before the migration.

### Updating your hosts file

Before DNS has been migrated we need to be able to test the top level service domain.

Use the `migration-hosts.sh` tool:

`tools/migration-hosts.sh put integration`

To remove:

`tools/migration-hosts.sh del integration`

### Running Smokey locally

Clone [Smokey](https://github.com/alphagov/smokey):

`git clone https://github.com/alphagov/smokey`

Move into the directory and bundle:

`cd smokey && bundle install`

Try running one of the tests:

`bundle exec cucumber features/frontend.feature`

If you receive an error about `phantomjs`, try installing the Homebrew package:

`brew cask install phantomjs`

If we wished to test against a different root domain, you should set the following environment variables:

`GOVUK_WEBSITE_ROOT`
`EXPECTED_GOVUK_WEBSITE_ROOT`

To run all tests:

`bundle exec rake`

Check the [Smokey](https://github.com/alphagov/smokey) repository for further details.
