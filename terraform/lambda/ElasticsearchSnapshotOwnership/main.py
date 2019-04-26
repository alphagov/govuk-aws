import boto3
import json
import os


def lambda_handler(event, context):
    client = boto3.client('s3')
    resource = boto3.resource('s3')

    my_identity = client.list_buckets()['Owner']['ID']
    user_identity = event['Records'][0]['userIdentity']['principalId']
    owner_identity = event['Records'][0]['s3']['bucket']['ownerIdentity']['principalId']

    # object is owned by somebody else
    if user_identity != my_identity:
        return

    # object already belongs to the owner of the bucket
    if user_identity == owner_identity:
        return

    # the object is owned by us and not the bucket owner, apply the
    # bucket-owner-full-control canned ACL.
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    object_key = event['Records'][0]['s3']['object']['key']
    object_acl = resource.ObjectAcl('bucket_name','object_key')
    object_acl.put(ACL='bucket-owner-full-control')
