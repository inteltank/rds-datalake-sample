REPOSITOY_NAME := rds-datalake
STAGE := dev
AWS_DEFAULT_REGION := ap-northeast-1
AWS_ACCOUNT_ID := 618687395710
ROOT := $(CURDIR)
PAYLOAD := eyJ0ZXh0IjoiaGVsbG8iLCAidGV4dDIiOiJoZWxsbyJ9Cg==

  



deploy: pip-install ## sls package with envs
	STAGE=$(STAGE) AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) AWS_ACCOUNT_ID=$(AWS_ACCOUNT_ID) sls deploy && :
	@osascript -e 'display notification "Finish Deploy" with title "${REPOSITOY_NAME}"'

replace: ## replace function files
	STAGE=$(STAGE) AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) AWS_ACCOUNT_ID=$(AWS_ACCOUNT_ID) sls deploy function --function start-exporting-snapshot

pip-install: ## pip install
	pip3 install -t $(ROOT)/layers/snapshot/python -r $(ROOT)/layers/snapshot/requirements.txt

pip-clean: ## clean up files via pip-install
	ls $(ROOT)/layers/snapshot/python/ | xargs rm -rf


package: pip-install ## sls package with envs
	STAGE=$(STAGE) AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) AWS_ACCOUNT_ID=$(AWS_ACCOUNT_ID) sls package --verbose
	@osascript -e 'display notification "Finish Package" with title "${REPOSITOY_NAME}"'

prepare-unit-tests:
	@docker container run \
		--name test-start-exporting-snapshot \
		--interactive \
		--rm \
		-e DOCKER_LAMBDA_STAY_OPEN=1 \
		--detach \
		-p 9001:9001 \
		--mount type=bind,src=${PWD},dst=/var/task \
		-v ${PWD}/layers/snapshot:/opt \
		--platform=linux/amd64 \
		lambci/lambda:python3.8 \
		functions/start-exporting-snapshot/app.handler

finish-unit-tests:
	@docker container stop test-start-exporting-snapshot

unit-tests: ## do lambda function@local
	echo $(ROOT)
	aws lambda invoke \
		--endpoint http://localhost:9001 \
		--no-sign-request \
		--function-name myfunction \
		--payload $(PAYLOAD) output.json
	@cat output.json | jq .

tests: unit-tests
	
help: ## self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
