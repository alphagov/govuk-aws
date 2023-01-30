import base64

import re

from urllib import request

def raise_if_not_an_amazonmq_url(url):
    if re.fullmatch(r'.*\.mq\.[a-z0-9_-]+\.amazonaws\.com/.*', url) is None:
        raise ValueError(f'Not a valid AmazonMQ URL: {url}')

def auth_digest(username, password):
    credentials = "%s:%s" % (username, password)
    return base64.b64encode(credentials.encode('UTF8'))

def add_headers(req, event):
    auth_header_value = b'Basic ' + auth_digest(event['username'], event['password'])
    req.add_header('Authorization', auth_header_value)

    req.add_header('Content-type', 'application/json')

    return req

def lambda_handler(event, context):
    raise_if_not_an_amazonmq_url(event['url'])

    raw_json = base64.b64decode(event['json_b64'])
    req = request.Request(event['url'], data=raw_json, method='POST', unverifiable=True)
    add_headers(req, event)

    print('Posting json to ', event['url'])
    resp = request.urlopen(req)

    print('Posted - status_code = ', resp.status)
    response_body = resp.read()
    print('Response body: (only present if an error occurred)', response_body)

    return {
        'statusCode': resp.status,
        'body': response_body
    }
