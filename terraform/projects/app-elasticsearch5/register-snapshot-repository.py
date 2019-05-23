# scp register-snapshot-repository.py [host]:
# ssh [host]
# virtualenv venv
# source venv/bin/activate
# pip install boto3 requests requests-aws4auth
# (assume the role)
# export AWS_ACCESS_KEY_ID='...'
# export AWS_SECRET_ACCESS_KEY='...'
# export AWS_SESSION_TOKEN='...'
# python register-snapshot-repository.py [integration|staging|production]

import os
import sys
import boto3
import requests
from requests_aws4auth import AWS4Auth

host = 'http://elasticsearch5/'
region = 'eu-west-1'
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

def register_repository(name, role_arn, delete_first=False, read_only=False):
    print(name)

    url = host + '_snapshot/' + name

    if delete_first:
        r = requests.delete(url)
        r.raise_for_status()
        print(r.text)

    payload = {
        "type": "s3",
        "settings": {
            "bucket": name + '-elasticsearch5-manual-snapshots',
            "region": region,
            "role_arn": role_arn,
            "readonly": read_only
        }
    }

    headers = {"Content-Type": "application/json"}

    r = requests.put(url, auth=awsauth, json=payload, headers=headers)
    r.raise_for_status()
    print(r.text)

delete_first = 'DELETE_FIRST' in os.environ

if sys.argv[1] == 'integration':
    role_arn = 'arn:aws:iam::210287912431:role/blue-elasticsearch5-manual-snapshot-role'
    register_repository('govuk-integration', role_arn, delete_first=delete_first)
    register_repository('govuk-staging', role_arn, delete_first=delete_first, read_only=True)
elif sys.argv[1] == 'staging':
    role_arn = 'arn:aws:iam::696911096973:role/blue-elasticsearch5-manual-snapshot-role'
    register_repository('govuk-staging', role_arn, delete_first=delete_first)
    register_repository('govuk-production', role_arn, delete_first=delete_first, read_only=True)
elif sys.argv[1] == 'production':
    role_arn = 'arn:aws:iam::172025368201:role/blue-elasticsearch5-manual-snapshot-role'
    register_repository('govuk-production', role_arn, delete_first=delete_first)
else:
    print('expected one of [integration|staging|production]')
