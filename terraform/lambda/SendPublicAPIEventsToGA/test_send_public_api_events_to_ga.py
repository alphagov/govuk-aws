from nose.tools import *
from mock import MagicMock
from mock import patch
from datetime import datetime
from datetime import timedelta

from send_public_api_events_to_ga import *

def valid_event():
    return {
        'Records': [{
            'eventName': 'ObjectCreated:something',
            's3': {
                'bucket': { 'name': 'some-bucket' },
                'object': { 'key': 'public_api_logs/logs.txt.gz' }
            }
        }]
    }

def test_get_bucket_name():
    event = valid_event()
    bucket_name = get_bucket_name(event['Records'][0])
    assert_equal("some-bucket", bucket_name)

def test_get_filename():
    event = valid_event()
    filename = get_filename(event['Records'][0])
    assert_equal('public_api_logs/logs.txt.gz', filename)

def test_calculate_time_delta():
    expected_delta = 300000
    five_minutes_ago = datetime.now() - timedelta(minutes=5)
    timestamp = int(round(five_minutes_ago.timestamp()))
    assert_almost_equal(expected_delta, calculate_time_delta(timestamp), delta=1000)

def test_send_events_to_GA():
    event = valid_event()
    five_minutes_ago = datetime.now() - timedelta(minutes=5)
    timestamp = str(int(round(five_minutes_ago.timestamp())))
    log_text = '\t'.join([
        timestamp,
        '200',
        '/api/content/foo',
        '127.0.0.1',
        'https://www.gov.uk/foo',
        'Mozilla',
        'GA1.1.1111111111.1111111111'
    ])
    with patch('send_public_api_events_to_ga.open_for_read') as mock_open_for_read:
        mock_open_for_read.return_value=io.StringIO(log_text)
        with patch('grequests.post') as mock_post:
            grequests.map = MagicMock(return_value=['<Response 200>'])
            response = send_events_to_GA({'Body': log_text})
            mock_post.assert_called()
            assert_equal(['<Response 200>'], response)

def test_handle_lambda():
    event = valid_event()
    S3.get_object = MagicMock(return_value={'Body': None})
    with patch('send_public_api_events_to_ga.send_events_to_GA') as mock:
        handle_lambda(event, None)
        mock.assert_called_with({'Body': None})

def test_handle_lambda_with_irrelevant_event():
    event = valid_event()
    event['Records'][0]['eventName'] = 'ObjectDeleted:something'
    S3.get_object = MagicMock(return_value={'Body': None})
    with patch('send_public_api_events_to_ga.send_events_to_GA') as mock:
        handle_lambda(event, None)
        mock.assert_not_called()

def test_handle_lambda_with_another_log_directory():
    event = valid_event()
    event['Records'][0]['s3']['object']['key'] = 'whitehall_assets/some.logs.gz'
    S3.get_object = MagicMock(return_value={'Body': None})
    with patch('send_public_api_events_to_ga.send_events_to_GA') as mock:
        handle_lambda(event, None)
        mock.assert_not_called()

