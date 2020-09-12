default: build-s3-lambda build-resize-lambda terraform-run
build-s3-lambda:
	cd s3-on-original-added-trigger-resize-lambda/ && \
	rm -rf dist && \
	npm run build && \
	cd ..
build-resize-lambda:
	cd image-resize-lambda/ && \
	rm -rf dist && \
	npm run build && \
	cd ..
terraform-run:
	cd terraform && \
	terraform apply && \
	cd ..
