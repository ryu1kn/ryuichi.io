
stack_name := ryuichi-io-website
template_file := cloudformation.yaml
region := ap-southeast-2

.PHONY: apply
apply:
	aws cloudformation deploy --stack-name $(stack_name) --template-file $(template_file) --region $(region)

.PHONY: delete
delete:
	aws cloudformation delete --stack-name $(stack_name) --region $(region)

changeset_name := ImportChangeSet

.PHONY: check-resource-identifier
check-resource-identifier:
	aws cloudformation get-template-summary \
		--template-body "file://$(template_file)"

.PHONY: create-changeset-for-import
create-changeset-for-import:
	aws cloudformation create-change-set --stack-name $(stack_name) \
		--change-set-type IMPORT \
		--change-set-name $(changeset_name) \
		--resources-to-import file://resources-to-import/content-bucket.json \
		--template-body "file://$(template_file)" \
		--region $(region)

.PHONY: import
import:
	aws cloudformation execute-change-set --stack-name $(stack_name) \
		--change-set-name $(changeset_name) \
		--region $(region)
