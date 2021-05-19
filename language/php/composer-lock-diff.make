$(COMPOSER_LOCK_DIFF): | $(COMPOSER) $(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)
	$(COMPOSER) global require davidrjonas/composer-lock-diff
	echo '$(COMPOSER) global exec -- composer-lock-diff $$@;\nexit $$?;' > "$(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)/composer-lock-diff"
	sudo ln -s "$(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)/composer-lock-diff" "$(COMPOSER_LOCK_DIFF)"
	sudo chmod +x $(COMPOSER_LOCK_DIFF)

composer-lock-diff: | $(COMPOSER_LOCK_DIFF)

optional:: | composer-lock-diff
