THIS_FILE := $(lastword $(MAKEFILE_LIST))

SHELL := /bin/bash

################
# PRE-REQUISITS

build:
	docker-compose build

##############
# ENVIRONMENT

confluence.start:
	docker-compose up -d confluence

confluence.logs:
	docker-compose logs -f confluence

confluence.stop:
	docker-compose up -d confluence

confluence.clean:
	docker-compose down

########################
# BUILDING & PUBLISHING

# Builds the assets: python diagrams and/or puml
publishAssets:
	source docPublishingScripts.sh && buildAssets

# Publishes to Confluence
# WARNING: Please fill in credentials in .env-confluence
publishToConfluence: publishAssets
	source docPublishingScripts.sh && publishConfluence

# Builds PDF book
publishToPDF: publishAssets
	source docPublishingScripts.sh && publishPDF

# Clean caches
clean:
	rm -rf $(CURDIR)/build
	# docker run --rm -v $(CURDIR):/docs alpine rm -rf /docs/build

