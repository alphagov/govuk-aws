# Redeploying Applications on Rebuild

There may be instances where an application machine is rebuilt.

All the applications should be automatically deployed to the new
machine. This is currently done by the deploy-apps userdata snippet,
which triggers the relevant Deploy Jenkins to deploy all the
applications for that node.

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
content-data-admin
content-data-api
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
service-manual-frontend
static
```

## Calculators Frontend

```
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
service-manual-frontend
static
```
