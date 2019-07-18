## WAFLogTrimmer

This AWS Lambda function processes the WAF firewall logs in the firehose to
drop any logs that matched the "default" action before they are shipped on to splunk.

This means that the logs should only contain "interesting" things for example
BLOCKED requests or ALLOWED requests that matched a rule and were explicitly
marked as ALLOW.

Without this processing of the WAF logs every single request would be sent for
indexing in splunk which would be of very little value.
