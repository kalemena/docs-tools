THIS_FILE := $(lastword $(MAKEFILE_LIST))

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


# Builds PDF book
publishToPDF:
	bash ./publishToPDF.sh

# Clean caches
clean:
	rm -rf build