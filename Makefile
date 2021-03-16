THIS_FILE := $(lastword $(MAKEFILE_LIST))

SHELL := /bin/bash

.PHONY: build

################
# PRE-REQUISITS

build:
	docker-compose -f src/main/docker/docker-compose.yml build

##############
# ENVIRONMENT

confluence.start:
	docker-compose -p docs -f src/main/docker/docker-compose.yml up -d confluence

confluence.logs:
	docker-compose -p docs -f src/main/docker/docker-compose.yml logs -f confluence

confluence.stop:
	docker-compose -p docs -f src/main/docker/docker-compose.yml up -d confluence

confluence.clean:
	docker-compose -p docs -f src/main/docker/docker-compose.yml down

########################
# BUILDING & PUBLISHING

# Builds the assets: python diagrams and/or puml
doc.publishAssets:
	source docPublishingScripts.sh && buildAssets

# Publishes to Confluence
# WARNING: Please fill in credentials in .env-confluence
doc.publishToConfluence: doc.publishAssets
	source docPublishingScripts.sh && publishConfluence

# Builds PDF book
doc.publishToPDF: doc.publishAssets
	source docPublishingScripts.sh && publishPDF

# Builds PDF book
doc.publishToHTML: doc.publishAssets
	source docPublishingScripts.sh && publishHTML

# Clean caches
doc.clean:
	rm -rf $(CURDIR)/build
	# docker run --rm -v $(CURDIR):/docs alpine rm -rf /docs/build

