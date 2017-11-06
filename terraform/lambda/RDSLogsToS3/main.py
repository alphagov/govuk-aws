import boto3
import botocore
import json
import os
from StringIO import StringIO

def lambda_handler(event, context):

  RDSInstanceName = os.environ['RDS_INSTANCE_NAME']
  S3BucketName = os.environ['S3_BUCKET_NAME']
  S3BucketPrefix = os.environ['S3_BUCKET_PREFIX']
  logNamePrefix = os.environ['LOG_NAME_PREFIX']
  lastReceivedFile = S3BucketPrefix + os.environ['LAST_RECEIVED_FILE']
  region = event['region']

  S3client = boto3.client('s3',region_name=region)
  RDSclient = boto3.client('rds',region_name=region)
  dbLogs = RDSclient.describe_db_log_files( DBInstanceIdentifier=RDSInstanceName, FilenameContains=logNamePrefix)
  lastWrittenTime = 0
  lastWrittenThisRun = None
  firstRun = False
  logFileData = ""

  try:
    S3client.head_bucket(Bucket=S3BucketName)
  except botocore.exceptions.ClientError as e:
    error_code = int(e.response['ResponseMetadata']['HTTPStatusCode'])
    if error_code == 404:
      raise Exception("Error: Bucket name provided not found")
    else:
      raise Exception("Error: Unable to access bucket name, error: " + e.response['Error']['Message'])

  try:
    lrfHandle = S3client.get_object(Bucket=S3BucketName, Key=lastReceivedFile)
  except botocore.exceptions.ClientError as e:
    error_code = int(e.response['ResponseMetadata']['HTTPStatusCode'])
    if error_code == 404:
      print("It appears this is the first log import, so all files will be retrieved from RDS.")
      firstRun = True
    else:
      raise Exception("Error: Unable to access lastReceivedFile name, error: " + e.response['Error']['Message'])

  if firstRun == False:
    lastWrittenTime = int(lrfHandle['Body'].read())
    if lastWrittenTime == 0 or lastWrittenTime == None:
      raise Exception("Error: Existing lastWrittenTime is " + lastWrittenTime)
    print("Found marker from last log download, retrieving log files with lastWritten time after %s" % str(lastWrittenTime))
	
  writes = 0;
  hasRun = False;

  for dbLog in dbLogs['DescribeDBLogFiles']:
    if ( int(dbLog['LastWritten']) > lastWrittenTime ) or firstRun:
      print("Downloading DB log file: %s found with LastWritten value of: %s " % (dbLog['LogFileName'], dbLog['LastWritten']))
			
      if int(dbLog['LastWritten']) > lastWrittenThisRun:
        lastWrittenThisRun = int(dbLog['LastWritten'])

      logFile = RDSclient.download_db_log_file_portion(DBInstanceIdentifier=RDSInstanceName, LogFileName=dbLog['LogFileName'], Marker='0')
      logFileData = logFile['LogFileData']
			
      while logFile['AdditionalDataPending']:
        logFile = RDSclient.download_db_log_file_portion(DBInstanceIdentifier=RDSInstanceName, LogFileName=dbLog['LogFileName'], Marker=logFile['Marker'])
        logFileData += logFile['LogFileData']
      byteData = str.encode(logFileData)
			
      try:
        objectName = S3BucketPrefix + dbLog['LogFileName']
        print("Attempting to write log file %s to S3 bucket %s" % (objectName, S3BucketName))
        S3client.put_object(Bucket=S3BucketName, Key=objectName, Body=byteData)
      except botocore.exceptions.ClientError as e:
        raise Exception("Error writing log file to S3 bucket, S3 ClientError: " + e.response['Error']['Message'])
			
      hasRun = True;
      writes+=1;
      print("Successfully wrote log file %s to S3 bucket %s" % (objectName, S3BucketName))
		
  # Otherwise, leave it alone
  if hasRun == True:	
    try:
      S3client.put_object(Bucket=S3BucketName, Key=lastReceivedFile, Body=str.encode(str(lastWrittenThisRun)))
    except botocore.exceptions.ClientError as e:
      raise Exception("Error writing marker to S3 bucket, S3 ClientError: " + e.response['Error']['Message'])
  else:
    print("No new log files were written during this execution.")

  print("------------ Writing of files to S3 complete:")
  print("Successfully wrote %s log files." % (writes))
  print("Successfully wrote new Last Written Marker to %s in Bucket %s" % (lastReceivedFile, S3BucketName))
	
  return "Log file export complete."

