COMPOSER_CHANGELOGS := $(shell command -v composer-changelogs || echo /usr/local/bin/composer-changelogs)

$(COMPOSER_CHANGELOGS): | $(COMPOSER) $(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)
	$(COMPOSER) global require pyrech/composer-changelogs
	echo '$(COMPOSER) global exec -- composer-changelogs $$@;\nexit $$?;' > "$(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)/composer-changelogs"
	sudo ln -s "$(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)/composer-changelogs" "$(COMPOSER_CHANGELOGS)"
	sudo chmod +x $(COMPOSER_CHANGELOGS)

composer-changelogs: | $(COMPOSER_CHANGELOGS)

optional:: | composer-changelogs
