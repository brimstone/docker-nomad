.PHONY: all docker-image docker-push
GOPATH=${PWD}

all: nomad docker-image docker-image-server docker-image-client docker-push

nomad:
	cd src/github.com/hashicorp/nomad; go get -v -d
	go build -a -installsuffix cgo -ldflags '-extldflags "-static"' github.com/hashicorp/nomad

docker-image: nomad
	docker build -t brimstone/nomad .

docker-image-server: nomad
	docker build -t brimstone/nomad:server -f Dockefile.server .

docker-image-client: nomad
	docker build -t brimstone/nomad:client -f Dockefile.client .

docker-push:
	@docker login -e="${DOCKER_EMAIL}" -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"
	docker push brimstone/nomad
