GITCONFIG := $(shell echo "$$HOME/.gitconfig")
GITIGNORE := $(shell echo "$$HOME/.gitignore")
GITPROJECTS := $(shell echo "$$HOME/git")

JETBRAINS_TOOLBOX := $(shell command -v jetbrains-toolbox || echo /usr/local/bin/jetbrains-toolbox)
JETBRAINS_TOOLBOX_SETTINGS := $(shell echo "$$HOME/.local/share/JetBrains/Toolbox/.settings.json")

CHROME := $(shell command -v google-chrome || echo /usr/bin/google-chrome)

DOCKER := $(shell command -v docker || echo /usr/bin/docker)
DOCKER_CONFIG := $(shell echo "$$HOME/.docker/config.json")

ZSH := $(shell command -v zsh || echo /usr/bin/zsh)
ZSHRC := $(shell echo "$$HOME/.zshrc")
OH_MY_ZSH := $(shell echo "$$HOME/.oh-my-zsh/oh-my-zsh.sh")

JQ := $(shell command -v jq || echo /usr/bin/jq)
CURL := $(shell command -v curl || echo /usr/bin/curl)
GIT := $(shell command -v git || echo /usr/bin/git)
BASH := $(shell command -v bash || echo /bin/bash)

install: \
	$(CHROME) \
	$(GIT) \
	$(ZSHRC) \
	$(OH_MY_ZSH) \
	$(DOCKER_CONFIG) \
	$(JETBRAINS_TOOLBOX_SETTINGS)

$(GITCONFIG):
	ln -s "$(shell pwd)/.gitconfig" "$(GITCONFIG)"

$(GITIGNORE):
	ln -s "$(shell pwd)/.gitignore" "$(GITIGNORE)"

$(GITPROJECTS):
	mkdir -p "$(GITPROJECTS)"

$(GIT): $(GITCONFIG) $(GITIGNORE) $(GITPROJECTS)
	@command -v git > /dev/null || sudo apt install git -y

$(JQ):
	sudo apt install jq -y

$(CURL):
	sudo apt install curl -y

$(JETBRAINS_TOOLBOX): $(JQ) $(CURL)
	$(CURL) -L --output - $(shell $(CURL) 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | $(JQ) '.TBA[0].downloads.linux.link' | sed 's/"//g') | tar zxf - -C /tmp
	sudo mv /tmp/jetbrains-toolbox-*/jetbrains-toolbox $(JETBRAINS_TOOLBOX)

$(JETBRAINS_TOOLBOX_SETTINGS): $(JETBRAINS_TOOLBOX)
	$(JETBRAINS_TOOLBOX)
	
$(DOCKER):
	sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(shell lsb_release -cs) stable"
	sudo apt update -y
	sudo apt install docker-ce docker-ce-cli containerd.io -y
	sudo usermod -aG docker $$USER
	newgrp docker
	sudo systemctl enable docker

$(DOCKER_CONFIG): $(DOCKER)
	sudo usermod -aG docker $$USER
	su -c 'docker run -it --rm hello-world' $$USER
	mkdir -p $(shell dirname $(DOCKER_CONFIG))
	echo '{}' > $(DOCKER_CONFIG)
	@echo ""
	@echo '!! You need to log out and log in before user "'$$USER'" can use the docker command !!'
	@echo ""

$(ZSH):
	sudo apt install zsh -y
	test '[[ "'$$CI'" == "" ]]' && chsh --shell $(ZSH)

$(ZSHRC):
	ln -s "$(shell pwd)/.zshrc" "$(ZSHRC)"

$(BASH):
	sudo apt install bash -y

$(OH_MY_ZSH): $(ZSH) $(CURL) $(BASH)
	$(CURL) -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
		| ZSH=$(shell dirname $(OH_MY_ZSH)) $(BASH) -s -- --keep-zshrc --unattended

$(CHROME): $(CURL)
	$(CURL) https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    		--output /tmp/google-chrome-stable_current_amd64.deb
	sudo dpkg --install /tmp/google-chrome-stable_current_amd64.deb
	rm -f /tmp/google-chrome-stable_current_amd64.deb