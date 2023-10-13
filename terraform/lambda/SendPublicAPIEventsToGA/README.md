# Lambda: SendPublicAPIEventsToGA

This lambda function processes logs in the S3 bucket `govuk-analytics-logs-production`.

It is triggered by `ObjectCreated` events on the bucket, it will only process S3 objects with the prefix `public_api_logs/`.

### Deployment

The deployment package for this lambda function is `send_public_events_to_ga.zip`.
In order to deploy any changes, the package needs to be updated.

Python 3.8 is required to deploy this lambda.
If you don't have 3.8, [pyenv](https://github.com/pyenv/pyenv) is a useful library for Python version management:

```
pyenv install 3.8
pyenv local 3.8
pip install virtualenv
```

Use the script for building the deployment package. This will create a virtualenv, install and package the dependencies.

```
./build_deployment_package.sh
```

### Tests

Install dependencies:

```
pip install -r requirements.txt
```

Run the tests:

```
nosetests test_send_public_api_events_to_ga.py
```
