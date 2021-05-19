COMPOSER := $(shell command -v composer || echo "$(DOCKER_COMPOSE_DEVELOPMENT)/bin/composer")
COMPOSER_CHANGELOGS := $(shell command -v composer-changelogs || echo /usr/local/bin/composer-changelogs)
COMPOSER_LOCK_DIFF := $(shell command -v composer-lock-diff || echo /usr/local/bin/composer-lock-diff)
