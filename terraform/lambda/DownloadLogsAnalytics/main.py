import re
import csv
import gzip
import boto3
import grequests
from io import TextIOWrapper
from datetime import datetime
from urllib.parse import unquote_plus

s3 = boto3.client("s3")

EVENT_REGEX = re.compile(r"^ObjectCreated:")
DOWNLOAD_REGEX = re.compile(r"^assets/")


def transform_row(row):
    timestamp, status, file_downloaded, ip, referrer, user_agent, ga_client_id = row

    # We do this because this lambda is only designed to track access
    # to an asset directly not via GOV.UK, because the latter can be
    # tracked on GOV.UK as a click event.
    if re.search("https://www.gov.uk/", referrer):
        return ""

    return {
        "timestamp": timestamp,
        "status": status,
        "file_downloaded": file_downloaded,
        "ip": ip,
        "referrer": referrer,
        "user_agent": user_agent,
        "ga_client_id": ga_client_id,
    }


def process(s3_object):
    csvreader = csv.reader(s3_object, delimiter="\t")
    data = []

    for row in csvreader:
        result = transform_row(row)
        if result is not "" and result is not None:
            data.append(result)

    return data


def parse_row(row):
    if row["ga_client_id"] != "":
        row["ga_client_id"] = parse_client_id(row["ga_client_id"])
    return row


def parse_client_id(client_id):
    client_id = client_id.replace("GA", "")
    client_id = client_id.split(".")[-2:]
    return ".".join(client_id)


def calculate_time_delta(timestamp):
    real_hit_time = datetime.fromtimestamp(int(timestamp))
    timedelta = datetime.now() - real_hit_time
    return int(timedelta.total_seconds() * 1000)


def construct_url(download_data):
    params = urllib.parse.urlencode(
        {
            "v": 1,
            "tid": "UA-26179049-7",
            "cid": download_data["ga_client_id"] or "No client id",
            "t": "event",
            "ec": "Download from External Source",
            "ea": download_data["file_downloaded"] or "No filename present",
            "el": download_data["referrer"] or "No referrer",
            "ua": download_data["user_agent"] or "No user agent",
            "uip": download_data["ip"] or "No IP",
            "dr": download_data["referrer"] or "No referrer",
            "cd13": download_data["user_agent"] or "No user agent",
            "cd14": download_data["ga_client_id"] or "No client id",
            "qt": calculate_time_delta(timestamp),
        }
    )
    return "http://www.google-analytics.com/collect?{0}".format(params)


def send_events_to_GA(bucket_name, bucket_key):
    try:
        obj = s3.get_object(Bucket=bucket_name, Key=bucket_key)
        s3_object = TextIOWrapper(gzip.GzipFile(fileobj=obj["Body"], mode="r"))
    except Exception as e:
        print("Error getting object {} from bucket {}.".format(key, bucket))
        print(e)
        raise e

    rows = process(s3_object)
    urls = []
    for row in rows:
        download_data = parse_row(row)
        url = construct_url(download_data)
        urls.append(url)

    rs = [grequests.post(u) for u in urls]
    return grequests.map(rs)


def lambda_handler(event, context):
    if event["Records"]:
        try:
            record = event["Records"][0]
            file_created = EVENT_REGEX.match(record["eventName"])
            is_download_event = DOWNLOAD_REGEX.match(record["s3"]["object"]["key"])
            if file_created and is_download_event:
                bucket_name = record["s3"]["bucket"]["name"]
                bucket_key = unquote_plus(record["s3"]["object"]["key"], encoding="utf-8")

                return send_events_to_GA(bucket_name, bucket_key)
        except Exception as e:
            print("Error sending assets to GA")
            print(e)
            raise e