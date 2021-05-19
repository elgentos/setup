$(COMPOSER): | $(DOCKER_COMPOSE_DEVELOPMENT)
composer: | $(COMPOSER)

install:: | composer
