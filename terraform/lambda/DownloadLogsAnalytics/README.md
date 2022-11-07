## DownloadLogsAnalytics

Uploads fastly asset logs to Google analytics.

The Lambda takes logs from the govuk-analytics-logs-production<br/>bucket and uploads them to Google analytics everytime a new log<br/>file is created in the bucket, which is currently every minute.
