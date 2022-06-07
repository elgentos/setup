$(DOCKER): | $(LSB_RELEASE) $(CURL) $(SOFTWARE_PROPERTIES_COMMON)
	sudo apt install apt-transport-https ca-certificates gnupg-agent -y
	$(CURL) -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(shell $(LSB_RELEASE) -cs) stable"
	sudo apt update -y
	sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
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
