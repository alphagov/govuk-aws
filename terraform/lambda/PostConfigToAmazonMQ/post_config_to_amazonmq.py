import base64
import json
import requests
import logging

from requests.auth import HTTPBasicAuth


def lambda_handler(event, context):
    raw_json = base64.b64decode(event['json_b64'])

    # write to file
    f = open('/tmp/json-config.json', 'wb')
    f.write(raw_json)
    f.close()

    print("raw_json = %s", raw_json)

    print('Posting... /tmp/json-config.json to %s', event['url'])
    headers = {'Content-type': 'application/json'}
    files = {'file': open('/tmp/json-config.json','rb')}
    r = requests.post(event['url'], files=files, auth=HTTPBasicAuth(event['username'], event['password']), headers=headers)
    print('Posted - status_code = %s', r.status_code)

    return {
        'statusCode': r.status_code,
        'body': r.content
    }
