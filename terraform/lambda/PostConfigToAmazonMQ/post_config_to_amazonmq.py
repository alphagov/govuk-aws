import base64
import json

from botocore.vendored import requests

def lambda_handler(event, context):
    raw_json = print(base64.b64decode(event['json_b64']))
    r = requests.post(event['url'], json=raw_json, auth=HTTPBasicAuth(event['username'], event['password']))
    
    return {
        'statusCode': r.status_code,
        'body': r.body()
    }
