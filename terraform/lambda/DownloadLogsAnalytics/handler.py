import re
from urllib.parse import unquote

from download_logs.aws_lambda import AWSLambda

EVENT_REGEX = re.compile(r'^ObjectCreated:')
DOWNLOAD_REGEX = re.compile(r'^assets/')


def handle_lambda(event, context):
    if event['Records']:
        for record in event['Records']:
            file_created = EVENT_REGEX.match(record['eventName'])
            is_download_event = DOWNLOAD_REGEX.match(record['s3']["object"]["key"])
            if file_created and is_download_event:
                bucket_name = record['s3']['bucket']['name']
                bucket_key = unquote(record['s3']['object']['key'])
                runner = AWSLambda(bucket_name, bucket_key)
                runner.send_events_to_GA()
