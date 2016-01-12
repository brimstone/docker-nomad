.PHONY: all build docker-image docker-push
GOPATH=${PWD}

all: build docker-image docker-push

build:
	cd src/github.com/hashicorp/nomad; go get -v -d
	CGO_ENABLED=0 go build -a -installsuffix cgo -ldflags '-s' github.com/hashicorp/nomad

docker-image:
	docker build -t brimstone/nomad .

docker-push:
	@docker login -e="${DOCKER_EMAIL}" -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"
	docker push brimstone/nomad
