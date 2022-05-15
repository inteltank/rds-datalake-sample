import requests, json

WEB_HOOK_URL = "https://hooks.slack.com/services/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"

def handler(event, context):
    requests.post(WEB_HOOK_URL,data=json.dumps({
        "text":"r"
        }))
