$(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN): | $(DOCKER_COMPOSE_DEVELOPMENT)
	mkdir -p "$(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)"

$(DOCKER_COMPOSE_DEVELOPMENT): | $(DOCKER) $(DOCKER_COMPOSE) $(DOCKER_CONFIG) $(GIT) $(GITPROJECTS) $(UFW) $(IP) $(SSH_KEY)
	$(GIT) clone git@github.com:JeroenBoersma/docker-compose-development.git $(DOCKER_COMPOSE_DEVELOPMENT)
	sudo service docker start
	for iface in $(shell $(IP) route | grep -Eo 'docker[0-9]' | uniq); do \
		sudo $(UFW) allow in on "$$iface" to any port 80 proto tcp; \
		sudo $(UFW) allow in on "$$iface" to any port 443 proto tcp; \
		sudo $(UFW) allow in on "$$iface" to any port 9000 proto tcp; \
	done
	echo $(INTERACTIVE) | grep -q '1' \
		&& "$(DOCKER_COMPOSE_DEVELOPMENT)/bin/dev" setup \
		|| DOMAINSUFFIX=.localhost egrep 'php[0-9][0-9]:' "$(DOCKER_COMPOSE_DEVELOPMENT)/docker-compose.yml" \
			| grep -v '-' | sort -ru | awk '{gsub(":","",$1); print $1}' | head -1 \
			| "$(DOCKER_COMPOSE_DEVELOPMENT)/bin/dev" setup

$(DOCKER_COMPOSE_DEVELOPMENT_PROFILE): | $(DOCKER_COMPOSE_DEVELOPMENT) $(ZSHRC)
	"$(DOCKER_COMPOSE_DEVELOPMENT)/bin/dev" profile > $(DOCKER_COMPOSE_DEVELOPMENT_PROFILE)
	echo 'for ws in "$$($(DOCKER_COMPOSE_DEVELOPMENT)/bin/dev workspace)"/*; do hash -d "$$(basename "$$ws")=$$ws"; done' \
		>> $(DOCKER_COMPOSE_DEVELOPMENT_PROFILE)

docker-compose-development: | $(DOCKER_COMPOSE_DEVELOPMENT_PROFILE)

install:: | docker-compose-development
