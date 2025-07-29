$(DOCKER): | $(LSB_RELEASE) $(CURL) $(SOFTWARE_PROPERTIES_COMMON)
	sudo apt-get update -y
	sudo apt-get install ca-certificates curl -y
	sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/$(DISTRO)/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$(DISTRO) \
      $(shell $(LSB_RELEASE) -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
	sudo usermod -aG docker $(shell whoami)
	sudo systemctl enable docker

$(DOCKER_CONFIG): | $(DOCKER)
	sudo usermod -aG docker $(shell whoami)
	echo $(INTERACTIVE) | grep -q '1' && su -c 'docker run --rm hello-world' $(shell whoami) || echo 'Skipping Docker test'
	mkdir -p $(shell dirname $(DOCKER_CONFIG))
	echo '{}' > $(DOCKER_CONFIG)
	@echo ""
	@echo '!! You need to log out and log in before user "'$$USER'" can use the docker command !!'
	@echo ""

docker: | $(DOCKER_CONFIG)

$(DOCKER_COMPOSE): | $(DOCKER) $(CURL) $(JQ)
	sudo $(CURL) -L $(shell $(CURL) -L https://api.github.com/repos/docker/compose/releases/latest \
			| jq '.assets[] | select(.name == "docker-compose-linux-x86_64").browser_download_url' \
			| sed 's/"//g') \
		--output $(DOCKER_COMPOSE)
	sudo chmod +x $(DOCKER_COMPOSE)

docker-compose: | $(DOCKER_COMPOSE)

install:: | docker docker-compose
