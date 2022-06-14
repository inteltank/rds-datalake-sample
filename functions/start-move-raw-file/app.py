import requests,json,boto3
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)
WEB_HOOK_URL = "https://hooks.slack.com/services/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"

def handler(event, context):
    logger.info(event)
    client = boto3.client('s3')
    task_name = event['detail']['SourceIdentifier'].split(":")[1]
    response = client.list_objects_v2(
        Bucket = "dev-rds-datalake-618687395710",
        Prefix = task_name
        )
    text = "task'{}' is conpleted\n```".format(task_name)
    for i in response['Contents']:
        text += "{}\n".format(i['Key'])
    text += "```"
    payload = {
            "text": text
            }
    response = requests.post(WEB_HOOK_URL,data=json.dumps(payload))
    logger.info(response)
