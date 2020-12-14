THIS_FILE := $(lastword $(MAKEFILE_LIST))

build:
	docker-compose build



# Clean caches
clean:
	rm -rf build