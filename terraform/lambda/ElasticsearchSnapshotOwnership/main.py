import boto3

def lambda_handler(event, context):
    resource = boto3.resource('s3')
    
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']

        try:
            object_acl = resource.ObjectAcl(bucket_name, object_key)
            object_acl.put(ACL='bucket-owner-full-control')
        except:
            pass
