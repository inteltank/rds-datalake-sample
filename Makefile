STAGE := dev
AWS_DEFAULT_REGION := ap-northeast-1
AWS_ACCOUNT_ID := 618687395710


deploy: ## sls package with envs
	STAGE=$(STAGE) AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) AWS_ACCOUNT_ID=$(AWS_ACCOUNT_ID) sls deploy

package: ## sls package with envs
	STAGE=$(STAGE) AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) AWS_ACCOUNT_ID=$(AWS_ACCOUNT_ID) sls package
	
help: ## self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
