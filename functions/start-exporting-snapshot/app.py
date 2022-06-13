import requests,json,boto3
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)
from boto3.session import Session
WEB_HOOK_URL = "https://hooks.slack.com/services/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"

def handler(event, context):
    
    logger.info(event)
    client = boto3.client('rds')
    resource_name = event['resources'][0]
    task_name = event['detail']['SourceIdentifier'].split(":")[1]
    response = client.start_export_task(
            ExportTaskIdentifier = task_name,
            SourceArn            = resource_name,
            S3BucketName         = 'dev-rds-datalake-618687395710',
            IamRoleArn           = 'arn:aws:iam::618687395710:role/dev-rds-datalake-rds-snapshot-export-role',
            KmsKeyId             = 'aa74c9ee-aaa0-4e8f-b9ff-36f1e4f0890f'
            )
    payload = {
            "text": "```{}```".format(json.dumps(event,indent=4))
            }
    response = requests.post(WEB_HOOK_URL,data=json.dumps(payload))
    logger.info(response)
