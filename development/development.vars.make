include dns/dns.vars.make

DOCKER_COMPOSE_DEVELOPMENT := $(shell echo "$$HOME/development")
DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE := $(shell dev workspace 2>/dev/null || echo "$(DOCKER_COMPOSE_DEVELOPMENT)/workspace")
DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN = $(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE)/bin
DOCKER_COMPOSE_DEVELOPMENT_PROFILE := $(shell echo "$$HOME/.zshrc-development")
DOCKER_COMPOSE_DEVELOPMENT_DNSMASQ := $(shell echo "$(DNSMASQ)/docker-compose-development.conf")
