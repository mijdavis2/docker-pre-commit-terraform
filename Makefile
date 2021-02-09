IMAGE_NAME = pre-commit-terraform
GIT_TAG = $(shell git describe --tags HEAD)
TAG ?= $(GIT_TAG)
DOCKER_REGISTRY ?= ghcr.io/mijdavis2
IMAGE_ID = $(DOCKER_REGISTRY)/$(IMAGE_NAME)

require:
	@docker --version >/dev/null 2>&1 || (echo "ERROR: docker is required."; exit 1)
	@pip --version >/dev/null 2>&1 || (echo "ERROR: pip is required."; exit 1)

init: require
	@pre-commit --version >/dev/null 2>&1 || (pip install pre-commit)
	@pre-commit install >/dev/null 2>&1

docker-build: require
	docker build -t $(IMAGE_ID):$(TAG) --build-arg "VERSION=$(TAG)" ./

docker-test: docker-build
	docker run --rm $(IMAGE_ID):$(TAG) ./tests/test-docker-image.sh
