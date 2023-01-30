# Lambda: PostConfigToAmazonMQ

This Lambda function posts the given 'json' to the given 'url', using the given 'username' and 'password' for Basic Auth.

It is invoked by terraform after creating the AmazonMQ broker, in order to apply the govuk-specific configuration that
defines the user accounts, virtual hosts, exchanges, queues and permissions that allow our applications to interact with it.

It will verify that the given URL matches the AmazonMQ pattern, to avoid any accidental use as a general proxy

### Deployment

Terraform will build and deploy the python package automatically

