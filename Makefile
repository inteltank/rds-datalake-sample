REPOSITOY_NAME := rds-datalake
STAGE := dev
AWS_DEFAULT_REGION := ap-northeast-1
AWS_ACCOUNT_ID := 618687395710
ROOT := $(CURDIR)


deploy: pip-install ## sls package with envs
	STAGE=$(STAGE) AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) AWS_ACCOUNT_ID=$(AWS_ACCOUNT_ID) sls deploy && :
	@osascript -e 'display notification "Finish Deploy" with title "${REPOSITOY_NAME}"'

replace: ## replace function files
	STAGE=$(STAGE) AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) AWS_ACCOUNT_ID=$(AWS_ACCOUNT_ID) sls deploy function --function start-exporting-snapshot

pip-install: ## pip install
	pip3 install -t $(ROOT)/layers/selenium/python -r $(ROOT)/layers/selenium/requirements.txt

pip-clean: ## clean up files via pip-install
	ls $(ROOT)/layers/selenium/python/ | grep -v -E 'chromedriver' | xargs rm -rf



package: pip-install ## sls package with envs
	STAGE=$(STAGE) AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) AWS_ACCOUNT_ID=$(AWS_ACCOUNT_ID) sls package --verbose
	@osascript -e 'display notification "Finish Package" with title "${REPOSITOY_NAME}"'
	
help: ## self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
