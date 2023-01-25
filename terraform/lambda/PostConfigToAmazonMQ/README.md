# Lambda: PostConfigToAmazonMQ

This lambda function posts the given 'json' to the given 'url', using the given 'username' and 'password' for Basic Auth.

It is invoked by terraform after creating the AmazonMQ broker, in order to apply the govuk-specific configuration that
defines the user accounts, virtual hosts, exchanges, queues and permissions that allow our applications to interact with it.

### Deployment

The deployment package for this lambda function is `post_config_to_amazonmq.zip`.
In order to deploy any changes, the package needs to be updated.

Python 3.9 is required to deploy this lambda.
If you don't have 3.9, [pyenv](https://github.com/pyenv/pyenv) is a useful library for Python version management:

```
pyenv install 3.9
pyenv local 3.9
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
