import base64
import json
import requests

from requests.auth import HTTPBasicAuth

def lambda_handler(event, context):
    print("event = %s", event)

    raw_json = print(base64.b64decode(event['json_b64']))
    json_str = raw_json.decode('ascii')

    print('Posting...')
    headers = {'Content-type': 'application/json'}
    r = requests.post(event['url'], data=json_str, auth=HTTPBasicAuth(event['username'], event['password']), headers=headers, verify=False)
    print('Posted - status_code = %s, text = %s', r.status_code, r.text)

    return {
        'statusCode': r.status_code,
        'body': r.content
    }
