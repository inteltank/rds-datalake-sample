import requests json
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

WEB_HOOK_URL = "https://hooks.slack.com/services/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"

def handler(event, context):
    options = Options()
    options.add_argument('--headless')
    driver = webdriver.Chrome('/opt/chromedriver', options=options)
    driver.get('https://www.google.co.jp')

    search_bar = driver.find_element_by_name("q")
    search_bar.send_keys('python')
    serach_bar.submit()

    for hrem_h3 in driver.find_element_by_xpath('//a/h3'):
        elem_a = elem_h3.find_element_by_xpath('..')
        return(elem_h3.text)
    requests.post(WEB_HOOK_URL,data=json.dumps({
        "text":"Hello World"
        }))
