import json
import requests

def lambda_handler(event, context):
    r = requests.post(event['url'], json=event['json'], auth=HTTPBasicAuth(event['username'], event['password']))
    
    return {
        'statusCode': r.status_code,
        'body': r.body()
    }
