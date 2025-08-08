$(DOCKER): | $(LSB_RELEASE) $(CURL) $(SOFTWARE_PROPERTIES_COMMON)
	sudo apt-get update
	sudo apt-get install ca-certificates curl gnupg lsb-release -y
	sudo mkdir -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/$(shell lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	echo "deb [arch=$(shell dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(shell lsb_release -is | tr '[:upper:]' '[:lower:]') $(shell lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
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

$(BACKBLAZE): | $(DOCKER_COMPOSE)
	wget https://github.com/Backblaze/B2_Command_Line_Tool/releases/latest/download/b2-linux -O $(BACKBLAZE)
	chmod +x $(BACKBLAZE)

backblaze: | $(BACKBLAZE)

install:: | docker docker-compose
optional:: | backblaze
