INTERACTIVE=1

GITCONFIG := $(shell echo "$$HOME/.gitconfig")
GITIGNORE := $(shell echo "$$HOME/.gitignore")
GITPROJECTS := $(shell echo "$$HOME/git")

JETBRAINS_TOOLBOX := $(shell command -v jetbrains-toolbox || echo /usr/local/bin/jetbrains-toolbox)
JETBRAINS_TOOLBOX_SETTINGS := $(shell echo "$$HOME/.local/share/JetBrains/Toolbox/.settings.json")

TRANSMISSION_REMOTE := $(shell command -v transmission-remote-gtk | echo /usr/bin/transmission-remote-gtk)

CHROME := $(shell command -v google-chrome || echo /usr/bin/google-chrome)

GIMP := $(shell command -v gimp || echo /usr/bin/gimp)

LIB_NVIDIA_GL := $(shell dpkg -l | grep -e 'libnvidia-gl-[0-9][0-9]*:amd64' | awk '{print $2}')
ZENITY := $(shell command -v zenity || echo /usr/bin/zenity)
STEAM := $(shell command -v steam || echo /bin/steam)
STEAM_TERMINAL := $(shell command -v xterm \
	|| command -v gnome-terminal \
	|| command -v konsole \
	|| command -v x-terminal-emulator \
	|| echo /usr/bin/gnome-terminal)

DOCKER := $(shell command -v docker || echo /usr/bin/docker)
DOCKER_CONFIG := $(shell echo "$$HOME/.docker/config.json")

ZSH := $(shell command -v zsh || echo /usr/bin/zsh)
ZSHRC := $(shell echo "$$HOME/.zshrc")
OH_MY_ZSH := $(shell echo "$$HOME/.oh-my-zsh/oh-my-zsh.sh")

JQ := $(shell command -v jq || echo /usr/bin/jq)
CURL := $(shell command -v curl || echo /usr/bin/curl)
GIT := $(shell command -v git || echo /usr/bin/git)
BASH := $(shell command -v bash || echo /bin/bash)

install: | \
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

$(GIT): | $(GITCONFIG) $(GITIGNORE) $(GITPROJECTS)
	sudo apt install git -y

$(JQ):
	sudo apt install jq -y

$(CURL):
	sudo apt install curl -y

$(JETBRAINS_TOOLBOX): | $(JQ) $(CURL)
	$(CURL) -L --output - $(shell $(CURL) 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | $(JQ) '.TBA[0].downloads.linux.link' | sed 's/"//g') | tar zxf - -C /tmp
	sudo mv /tmp/jetbrains-toolbox-*/jetbrains-toolbox $(JETBRAINS_TOOLBOX)

$(JETBRAINS_TOOLBOX_SETTINGS): | $(JETBRAINS_TOOLBOX)
	mkdir -p $(shell dirname $(JETBRAINS_TOOLBOX_SETTINGS))
	echo $(INTERACTIVE) | grep -q '1' && $(JETBRAINS_TOOLBOX) || echo '{}' > $(JETBRAINS_TOOLBOX_SETTINGS)
	
$(DOCKER):
	sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(shell lsb_release -cs) stable"
	sudo apt update -y
	sudo apt install docker-ce docker-ce-cli containerd.io -y
	sudo usermod -aG docker $$USER
	newgrp docker
	sudo systemctl enable docker

$(DOCKER_CONFIG): | $(DOCKER)
	sudo usermod -aG docker $$USER
	echo $(INTERACTIVE) | grep -q '1' && su -c 'docker run --rm hello-world' $$USER || echo 'Skipping Docker test'
	mkdir -p $(shell dirname $(DOCKER_CONFIG))
	echo '{}' > $(DOCKER_CONFIG)
	@echo ""
	@echo '!! You need to log out and log in before user "'$$USER'" can use the docker command !!'
	@echo ""

$(ZSH):
	sudo apt install zsh -y
	echo $(INTERACTIVE) | grep -q '1' && chsh --shell $(ZSH) || echo 'Skipping shell change'

$(ZSHRC):
	ln -s "$(shell pwd)/.zshrc" "$(ZSHRC)"

$(BASH):
	sudo apt install bash -y

$(OH_MY_ZSH): | $(ZSH) $(CURL) $(BASH)
	$(CURL) -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
		| ZSH=$(shell dirname $(OH_MY_ZSH)) $(BASH) -s -- --keep-zshrc --unattended

$(CHROME): | $(CURL)
	$(CURL) -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    		--output /tmp/google-chrome-stable_current_amd64.deb
	sudo dpkg --install /tmp/google-chrome-stable_current_amd64.deb
	rm -f /tmp/google-chrome-stable_current_amd64.deb

optional: | \
	transmission-remote \
	gimp \
	steam

$(TRANSMISSION_REMOTE):
	sudo apt install transmission-remote-gtk -y

transmission-remote: | $(TRANSMISSION_REMOTE)

$(GIMP):
	sudo apt install gimp -y

gimp: | $(GIMP)

$(STEAM_TERMINAL):
	sudo apt install xterm -y

$(ZENITY):
	sudo apt install zenity -y

$(STEAM): | $(CURL) $(STEAM_TERMINAL) $(ZENITY)
	# See: https://github.com/ValveSoftware/steam-for-linux/issues/7067#issuecomment-622390607
	echo $(LIB_NVIDIA_GL) | grep -q ':amd64' \
		&& sudo apt install $(shell echo $(LIB_NVIDIA_GL) | cut -d: -f1):i386 -y \
		|| echo 'Skipping NVIDIA closed driver fix'
	rm -rf $$HOME/.steam
	$(CURL) -L https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb \
		--output /tmp/steam.deb
	sudo dpkg --install /tmp/steam.deb
	rm -f /tmp/steam.deb
	sudo apt update -y
	sudo apt install libgl1-mesa-dri:i386 libgl1:i386 libc6:i386 -y

steam: | $(STEAM)