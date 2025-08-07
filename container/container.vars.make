DOCKER := $(shell command -v docker || echo /usr/bin/docker)
DOCKER_CONFIG := $(shell echo "$$HOME/.docker/config.json")
DOCKER_COMPOSE := $(shell command -v docker-compose || echo /usr/local/bin/docker-compose)
BACKBLAZE := $(shell command -v b2 || echo $(HOME)/development/bin/b2)
