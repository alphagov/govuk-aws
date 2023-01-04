from datetime import datetime
import csv
import grequests
import gzip
import io
import os
import re
import urllib

EVENT_REGEX = re.compile(r'^ObjectCreated:')
PUBLIC_API_LOG_REGEX = re.compile(r'^public_api_logs/')

import boto3
S3 = boto3.client('s3')

def handle_lambda(event, context):
    try:
        if event['Records']:
            record = event['Records'][0]
            file_created = EVENT_REGEX.match(record['eventName'])
            filename = get_filename(record)
            is_public_api_log_event = PUBLIC_API_LOG_REGEX.match(filename)
            if file_created and is_public_api_log_event:
                bucket_name = get_bucket_name(record)
                obj = S3.get_object(Bucket=bucket_name, Key=filename)
                send_events_to_GA(obj)
    except Exception as e:
        print(e)

def get_bucket_name(record):
    return record['s3']['bucket']['name']

def get_filename(record):
    return urllib.parse.unquote(record['s3']['object']['key'])

def calculate_time_delta(timestamp):
    real_hit_time = datetime.fromtimestamp(int(timestamp))
    timedelta = datetime.now() - real_hit_time
    return int(timedelta.total_seconds() * 1000)

def open_for_read(s3_object):
    return io.TextIOWrapper(gzip.GzipFile(fileobj=s3_object['Body'], mode='r'))

def send_events_to_GA(s3_object):
    urls = []
    csvreader = csv.reader(open_for_read(s3_object), delimiter="\t")
    for row in csvreader:
        timestamp, status, path, ip, referrer, user_agent, ga_client_id = row
        timestamp = timestamp or int(round(datetime.now().timestamp()))
        params = urllib.parse.urlencode({
            'v': 1,
            'tid': os.getenv('TRACKING_ID', 'UA-26179049-14'), # FIXME: Add value to env.
            'cid': ga_client_id,
            't': 'pageview',
            'uip': ip,
            'aip': 1,
            'ds': 'Public API request',
            'dp': path,
            'dr': referrer,
            'ua': user_agent,
            'qt': calculate_time_delta(timestamp)
        })
        url = "http://www.google-analytics.com/collect?{0}".format(params)
        urls.append(url)

    rs = [grequests.post(u) for u in urls]

    return grequests.map(rs)
