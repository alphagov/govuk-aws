FROM public.ecr.aws/lambda/python:3.7

RUN pip install boto3 grequests requests python-dateutil urllib3

COPY main.py ${LAMBDA_TASK_ROOT}

CMD [ "main.lambda_handler" ]