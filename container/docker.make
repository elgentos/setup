$(DOCKER): | $(LSB_RELEASE) $(CURL) $(SOFTWARE_PROPERTIES_COMMON)
	# Verwijder eventuele oude versies van Docker
	sudo apt-get remove docker docker-engine docker.io containerd runc &&

	# Update de pakketlijst en installeer vereiste pakketten
	sudo apt-get update &&
	sudo apt-get install -y \
		ca-certificates \
		curl \
		gnupg \
		lsb-release &&

	# Maak de keyring directory aan en voeg de Docker GPG-sleutel toe
	sudo mkdir -p /etc/apt/keyrings &&
	curl -fsSL https://download.docker.com/linux/$(DISTRO)/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&

	# Voeg de Docker repository toe aan de APT-bronnenlijst
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(DISTRO) \
	  $(shell lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&

	# Update de pakketlijst opnieuw en installeer Docker
	sudo apt-get update &&
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin &&

	# Voeg de huidige gebruiker toe aan de Docker-groep
	sudo usermod -aG docker $(shell whoami) &&

	# Zorg ervoor dat Docker automatisch start bij het opstarten
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
