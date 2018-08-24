from datetime import date, timedelta
import os

import boto3


athena = boto3.client('athena')


def get_query_string():
    named_query_id = os.environ['NAMED_QUERY_ID']
    response = athena.get_named_query(NamedQueryId=named_query_id)
    return response['NamedQuery']['QueryString']


def generate_output_location():
    bucket_name = os.environ['BUCKET_NAME']
    yesterday = date.today() - timedelta(days=1)
    filename = f'athena_{yesterday.isoformat()}'
    return f's3://{bucket_name}/{filename}'


def execute_query(query_string):
    database_name = os.environ['DATABASE_NAME']
    output_location = generate_output_location()

    athena.start_query_execution(
        QueryString=query_string,
        QueryExecutionContext={
            'Database': database_name,
        },
        ResultConfiguration={
            'OutputLocation': output_location,
        },
    )


def lambda_handler(*args, **kwargs):
    query_string = get_query_string()
    execute_query(query_string)
