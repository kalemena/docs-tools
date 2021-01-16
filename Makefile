THIS_FILE := $(lastword $(MAKEFILE_LIST))

SHELL := /bin/bash

################
# PRE-REQUISITS

build:
	docker-compose -f src/main/docker/docker-compose.yml build

##############
# ENVIRONMENT

confluence.start:
	docker-compose -f src/main/docker/docker-compose.yml up -d confluence

confluence.logs:
	docker-compose -f src/main/docker/docker-compose.yml logs -f confluence

confluence.stop:
	docker-compose -f src/main/docker/docker-compose.yml up -d confluence

confluence.clean:
	docker-compose -f src/main/docker/docker-compose.yml down

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

