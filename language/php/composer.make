COMPOSER := $(shell command -v composer || echo "$(DOCKER_COMPOSE_DEVELOPMENT)/bin/composer")

$(COMPOSER): | $(DOCKER_COMPOSE_DEVELOPMENT)
composer: | $(COMPOSER)

install:: | composer
