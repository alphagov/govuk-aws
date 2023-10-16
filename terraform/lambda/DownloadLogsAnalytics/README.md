# Lambda: DownloadLogsAnalytics

The Lambda takes logs from the `govuk-analytics-logs-production` bucket and uploads them to Google analytics everytime a new log file is created in the bucket, which is currently every minute.

It is triggered by `ObjectCreated` events on the bucket, it will only process S3 objects with the prefix `assets/`.

### Deployment

The deployment package for this lambda function is `download_logs_analytics.zip`.
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
nosetests test/test_aws_lambda_test.py
```
