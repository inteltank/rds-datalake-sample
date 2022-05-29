import requests,json,boto3
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)
from boto3.session import Session
WEB_HOOK_URL = "https://hooks.slack.com/services/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"

def handler(event, context):
    
    logger.info(event)
#    profile _= "execute-export-rds-snapshot"
#    session = Session(profile_name=profile)
#    client = session.client('rds')
#    response = client.start_export_task(
#            ExportTaskIdentifier='rds-datalake-2022-20-01',
#            SourceArn='arn:aws:rds:ap-northeast-1:618687395710:snapshot:rds:dev-rds-datalake-2022-05-13-18-04',
#            S3BucketName='dev-rds-datalake-618687395710',
#            IamRoleArn='rds-export-role',
#            IamRoleArn='arn:aws:iam::618687395710:role/dev-rds-datalake-rds-snapshot-export-role'
#            KmsKeyId='aa74c9ee-aaa0-4e8f-b9ff-36f1e4f0890f',
#            # S3Prefix='string',
#            ExportOnly=['database']
#            )
    payload = {
            "text": json.dumps(event)
            }
    response = requests.post(WEB_HOOK_URL,data=json.dumps(payload))
    logger.info(response)


