.PHONY: all docker-image docker-image-server docker-image-client docker-push test-server test-client
GOPATH=${PWD}

all: nomad docker-image docker-image-server docker-image-client docker-push

nomad:
	cd src/github.com/hashicorp/nomad; go get -v -d
	docker run --rm -it -v "${PWD}:/go" -u "${UID}:${GID}" brimstone/golang-musl github.com/hashicorp/nomad

docker-image: nomad
	docker build -t brimstone/nomad .

docker-image-server: nomad
	docker build -t brimstone/nomad:server -f Dockerfile.server .

docker-image-client: nomad
	docker build -t brimstone/nomad:client -f Dockerfile.client .

docker-push:
	@docker login -e="${DOCKER_EMAIL}" -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"
	docker push brimstone/nomad

test-server:
	docker run -d --name nomad brimstone/nomad:server -bootstrap-expect=1

test-client:
	docker run -d --name client \
	-v /var/run/docker.sock:/var/run/docker.sock \
	--net host \
	brimstone/nomad:client \
	-servers $(shell docker inspect -f '{{.NetworkSettings.IPAddress}}' nomad):4647 \
	-log-level=DEBUG
