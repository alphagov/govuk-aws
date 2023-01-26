import base64
import json
import requests
import logging

from requests.auth import HTTPBasicAuth

def lambda_handler(event, context):
    # Initialize you log configuration using the base class
    logging.basicConfig(level = logging.INFO)

    # Retrieve the logger instance
    logger = logging.getLogger()

    logger.info("event = %s", event)

    raw_json = print(base64.b64decode(event['json_b64']))

    logger.info("raw_json = %s", raw_json)

    logger.info('Posting...')
    r = requests.post(event['url'], json=raw_json, auth=HTTPBasicAuth(event['username'], event['password']))
    logger.info('Posted - status_code = %s', r.status_code)
    
    return {
        'statusCode': r.status_code,
        'body': r.body()
    }
