# Redeploying Applications on Rebuild

There may be instances where an application machine is rebuilt.

At present applications are not automatically deployed on rebuild. This will be
rectified in the future.

## Redeploying from Jenkins CLI

The quickest way to redeploy apps is from the Jenkins CLI:

1. SSH to Jenkins instance
2. Create a text file for all apps that need to be deployed (listed below)
3. `export JOBSLIST=<file>`
4. `for i in $(cat $JOBSLIST); do sudo jenkins-cli build -p TARGET_APPLICATION=$i -p DEPLOY_TASK=deploy -p TAG=release "Deploy_App"; done`

This will trigger all the apps to redeploy. It assumes that each app will be released using the newest `release` tag.

# Application list by machine instance

## Backend

```
asset-manager
collections-publisher
contacts
content-performance-manager
content-tagger
email-alert-api
email-alert-service
hmrc-manuals-api
imminence
link-checker-api
local-links-manager
kibana
manuals-publisher
maslow
policy-publisher
publisher
release
search-admin
service-manual-publisher
short-url-manager
sidekiq-monitoring
signon
specialist-publisher
support
support-api
transition
travel-advice-publisher
```

## Frontend

```
canary-frontend
collections
designprinciples
email-alert-frontend
feedback
frontend
government-frontend
info-frontend
manuals-frontend
service-manual-frontend
static
```

## Calculators Frontend

```
calculators
calendars
finder-frontend
licencefinder
smartanswers
```

## Draft Frontend

```
collections
email-alert-frontend
frontend
government-frontend
manuals-frontend
service-manual-frontend
static
```
