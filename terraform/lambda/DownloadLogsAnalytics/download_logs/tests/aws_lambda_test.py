from nose.tools import assert_equal
import os
import csv
from collections import deque
from mock import MagicMock
import urllib.parse
import grequests

from download_logs.aws_lambda import AWSLambda


def get_file(path, filename):
    return open(get_path(path, filename), 'r')


def get_path(path, filename):
    return os.path.join(*path, filename)


def get_last_row(csv_filename):
    with open(csv_filename, 'r') as f:
        lastrow = None
        lastrow = deque(csv.reader(f, delimiter="\t"), 1)[0]
        return lastrow


def test_base():
    log_file = "2017-05-26T10-00-00.000-wZe41G6PdJYziQ8AAAAA.log"
    aws_lambda = AWSLambda("MockBucket", log_file)

    assert_equal(aws_lambda.bucket, "MockBucket")
    assert_equal(aws_lambda.filename, log_file)


def test_process():
    expected = [{
                 'timestamp': '1495792799',
                 'status': '206',
                 'file_downloaded': '/government/uploads/system/uploads/attachment_data/file/224634/Children_travelling_to_the_UK_leaflet_A5_WEB_final.pdf',
                 'ip': '11.111.111.111',
                 'referrer': '',
                 'user_agent': 'Mozilla/5.0 (Windows Phone 8.1; ARM; Trident/7.0; Touch; rv:11.0; IEMobile/11.0; Microsoft; Lumia 640 LTE) like Gecko',
                 'ga_client_id': 'GA1.1.1111111111.1111111111'
                },
                {
                 'timestamp': '1495792859',
                 'status': '200',
                 'file_downloaded': '/government/uploads/system/uploads/attachment_data/file/417696/Archived-information_sharing_guidance_for_practitioners_and_managers.pdf',
                 'ip': '11.111.111.111',
                 'referrer': 'https://www.bing.com/',
                 'user_agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10586',
                 'ga_client_id': 'GA1.1.1111111111.1111111111'
                }]

    aws_lambda = AWSLambda("MockBucket", "2017-05-26T10-00-00.000-wZe41G6PdJYziQ8AAAAA.log")
    test_log_file = get_file(['tests'], aws_lambda.filename)
    AWSLambda.open_for_read = MagicMock(return_value=test_log_file)

    processed_values = aws_lambda.process()

    assert_equal(processed_values, expected)


def test_transform_row():
    expected = {'timestamp': '1495792859',
                'status': '200',
                'file_downloaded': '/government/uploads/system/uploads/attachment_data/file/417696/Archived-information_sharing_guidance_for_practitioners_and_managers.pdf',
                'ip': '11.111.111.111',
                'referrer': 'https://www.bing.com/',
                'user_agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10586',
                'ga_client_id': 'GA1.1.1111111111.1111111111'}

    aws_lambda = AWSLambda("MockBucket", "2017-05-26T10-00-00.000-wZe41G6PdJYziQ8AAAAA.log")
    path = get_path(['tests'], aws_lambda.filename)
    row = get_last_row(path)

    transformed_row = aws_lambda.transform_row(row)

    assert_equal(transformed_row, expected)


def test_parse_client_id():
    expected = "1111111111.1111111111"
    aws_lambda = AWSLambda("MockBucket", "2017-05-26T10-00-00.000-wZe41G6PdJYziQ8AAAAA.log")

    client_id = aws_lambda.parse_client_id('GA1.1.1111111111.1111111111')
    assert_equal(client_id, expected)


def test_construct_url():
    property_id = 'UA-26179049-7'
    ga_client_id = '1111111111.1111111111'
    user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10586'
    file = '/government/uploads/system/uploads/attachment_data/file/417696/Archived-information_sharing_guidance_for_practitioners_and_managers.pdf'
    referrer = 'https://www.bing.com/'
    ip = '11.111.111.111'

    download_data = {'timestamp': '1495792859',
                     'status': '200',
                     'file_downloaded': file,
                     'ip': ip,
                     'referrer': referrer,
                     'user_agent': user_agent,
                     'ga_client_id': ga_client_id}

    aws_lambda = AWSLambda("MockBucket", "2017-05-26T10-00-00.000-wZe41G6PdJYziQ8AAAAA.log")

    url = aws_lambda.construct_url(download_data)
    latency = aws_lambda.calculate_time_delta(download_data['timestamp'])

    params = urllib.parse.urlencode({
                                    'v': 1,
                                    'tid': property_id,
                                    'cid': ga_client_id,
                                    't': 'event',
                                    'ec': 'Download from External Source',
                                    'ea': file,
                                    'el': referrer,
                                    'ua': user_agent,
                                    'uip': ip,
                                    'dr': referrer,
                                    'cd13': user_agent,
                                    'cd14': ga_client_id,
                                    'qt': latency
                                    })
    expected_url = "http://www.google-analytics.com/collect?{0}".format(params)

    assert_equal(url, expected_url)


def test_send_events_to_GA():
    processed_values = [{'timestamp': '1495792859',
                         'status': '200',
                         'file_downloaded': '/government/uploads/system/uploads/attachment_data/file/417696/Archived-information_sharing_guidance_for_practitioners_and_managers.pdf',
                         'ip': '11.111.111.111',
                         'referrer': 'https://www.bing.com/',
                         'user_agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10586',
                         'ga_client_id': 'GA1.1.1111111111.1111111111'}]

    aws_lambda = AWSLambda("MockBucket", "2017-05-26T10-00-00.000-wZe41G6PdJYziQ8AAAAA.log")
    aws_lambda.process = MagicMock(return_value=processed_values)
    aws_lambda.construct_url = MagicMock(return_value="http://www.google-analytics.com/collect?{0}")

    grequests.map = MagicMock(return_value=["<Response [200]>"])

    response = aws_lambda.send_events_to_GA()

    assert_equal(response, ["<Response [200]>"])
