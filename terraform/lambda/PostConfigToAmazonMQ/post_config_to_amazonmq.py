import base64
import json
import requests
import re

from requests.auth import HTTPBasicAuth

def raise_if_not_an_amazonmq_url(url):
    if re.fullmatch('.*\.mq\.[a-z0-9_-]+\.amazonaws\.com/.*', url) == None:
        raise ValueError(f'url failed validation: {url}')

def lambda_handler(event, context):
    raw_json = base64.b64decode(event['json_b64'])
    json_str = raw_json.decode('ascii')

    raise_if_not_an_amazonmq_url(event['url'])

    print('Posting json to ', event['url'])
    headers = {'Content-type': 'application/json'}
    r = requests.post(event['url'], data=json_str, auth=HTTPBasicAuth(event['username'], event['password']), headers=headers)
    
    print('Posted - status_code = ', r.status_code)
    print('Response body: (only present if an error occurred)', r.text)

    return {
        'statusCode': r.status_code,
        'body': r.content
    }
