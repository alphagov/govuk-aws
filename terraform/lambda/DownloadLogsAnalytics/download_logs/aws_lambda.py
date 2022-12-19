from .base import Base
import re
import gzip
import csv
import urllib.parse
from io import TextIOWrapper
import grequests
from datetime import datetime

import boto3
s3 = boto3.client('s3')


class AWSLambda(Base):
    def __init__(self, bucket, filename):
        self.bucket = bucket
        super().__init__(filename)

    def open_for_read(self):
        obj = s3.get_object(Bucket=self.bucket, Key=self.filename)
        return TextIOWrapper(gzip.GzipFile(fileobj=obj['Body'], mode='r'))

    def transform_row(self, row):
        try:
            timestamp, status, file_downloaded, ip, referrer, user_agent, ga_client_id = row

            # We do this because this lambda is only designed to track access
            # to an asset directly not via GOV.UK, because the latter can be
            # tracked on GOV.UK as a click event.
            if re.search('https://www.gov.uk/', referrer):
                return ""

            return {
                'timestamp': timestamp,
                'status': status,
                'file_downloaded': file_downloaded,
                'ip': ip,
                'referrer': referrer,
                'user_agent': user_agent,
                'ga_client_id': ga_client_id
            }
        except:
            print(row)
            raise

    def process(self):
        csvreader = csv.reader(self.open_for_read(), delimiter="\t")
        data = []

        for row in csvreader:
            result = self.transform_row(row)
            if result is not '' and result is not None:
                data.append(result)

        return data

    def parse_row(self, row):
        if row['ga_client_id'] != '':
            row['ga_client_id'] = self.parse_client_id(row['ga_client_id'])
        return row

    def parse_client_id(self, client_id):
        client_id = client_id.replace('GA', '')
        client_id = client_id.split(".")[-2:]
        return ".".join(client_id)

    def calculate_time_delta(self, timestamp):
        real_hit_time = datetime.fromtimestamp(int(timestamp))
        timedelta = datetime.now() - real_hit_time
        return int(timedelta.total_seconds() * 1000)

    def construct_url(self, download_data):
        property_id = 'UA-26179049-7'
        ga_client_id = download_data['ga_client_id'] or 'No client id'
        category = 'Download from External Source'
        filename = download_data['file_downloaded'] or 'No filename present'
        referrer = download_data['referrer'] or 'No referrer'
        user_agent = download_data['user_agent'] or 'No user agent'
        ip = download_data['ip'] or 'No IP'
        timestamp = download_data['timestamp'] or datetime.now()
        latency = self.calculate_time_delta(timestamp)

        params = urllib.parse.urlencode({
                                        'v': 1,
                                        'tid': property_id,
                                        'cid': ga_client_id,
                                        't': 'event',
                                        'ec': category,
                                        'ea': filename,
                                        'el': referrer,
                                        'ua': user_agent,
                                        'uip': ip,
                                        'dr': referrer,
                                        'cd13': user_agent,
                                        'cd14': ga_client_id,
                                        'qt': latency
                                        })
        return "http://www.google-analytics.com/collect?{0}".format(params)

    def send_events_to_GA(self):
        rows = self.process()
        urls = []
        for row in rows:
            download_data = self.parse_row(row)
            url = self.construct_url(download_data)
            urls.append(url)

        rs = [grequests.post(u) for u in urls]

        return grequests.map(rs)
