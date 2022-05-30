import requests,json,boto3
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)
WEB_HOOK_URL = "https://hooks.slack.com/services/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"

def handler(event, context):
    logger.info(event)
    payload = {
            "text": "```{}```".format(json.dumps(event,indent=4))
            }
    response = requests.post(WEB_HOOK_URL,data=json.dumps(payload))
    logger.info(response)
