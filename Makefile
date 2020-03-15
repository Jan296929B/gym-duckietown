AIDO_REGISTRY ?= docker.io
branch=$(shell git rev-parse --abbrev-ref HEAD)

img3=$(AIDO_REGISTRY)/duckietown/gym-duckietown-server-python3:$(branch)

all:
	@echo ## Containerized Python 2 support
	@echo
	@echo To build all containers:
	@echo
	@echo    make build-docker-python3
	@echo
	@echo To push to:
	@echo
	@echo  $(img3)
	@echo
	@echo To develop in the container (deps in container, code in this dir), use:
	@echo
	@echo    make shell-docker-python2-ros
	@echo
	@echo Inside, remember to start  launch-xvfb


build: update-reqs
	$(MAKE) build-docker-python3

push:
	$(MAKE) push-docker-python3

update-reqs:
	pur -r requirements.txt -f -m '*' -o requirements.resolved
	aido-update-reqs requirements.resolved

build-docker-python3: update-reqs
	docker build --pull -t $(img3) -f docker/AIDO1/server-python3/Dockerfile .

build-docker-python3-no-cache: update-reqs
	docker build --pull -t $(img3) -f docker/AIDO1/server-python3/Dockerfile .


push-docker-python3:
	docker push $(img3)



other_deps:
	apt install x11-apps

bump-upload:
	bumpversion patch
	git push --tags
	git push --all
	rm -f dist/*
	rm -rf src/*.egg-info
	python setup.py sdist
	twine upload dist/*
