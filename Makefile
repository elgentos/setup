INTERACTIVE=1

GITCONFIG_USER := $(shell echo "$$HOME/.gitconfig-user")
GITCONFIG := $(shell echo "$$HOME/.gitconfig")
GITIGNORE := $(shell echo "$$HOME/.gitignore")
GITPROJECTS := $(shell echo "$$HOME/git")

JETBRAINS_TOOLBOX := $(shell command -v jetbrains-toolbox || echo /usr/local/bin/jetbrains-toolbox)
JETBRAINS_TOOLBOX_SETTINGS := $(shell echo "$$HOME/.local/share/JetBrains/Toolbox/.settings.json")

TRANSMISSION_REMOTE := $(shell command -v transmission-remote-gtk || echo /usr/bin/transmission-remote-gtk)

CHROME := $(shell command -v google-chrome || echo /usr/bin/google-chrome)

GIMP := $(shell command -v gimp || echo /usr/bin/gimp)

DISCORD := $(shell command -v discord || echo /usr/bin/discord)

LIB_NVIDIA_GL := $(shell dpkg -l | grep -e 'libnvidia-gl-[0-9][0-9]*:amd64' | awk '{print $2}')
ZENITY := $(shell command -v zenity || echo /usr/bin/zenity)
STEAM := $(shell command -v steam || echo /bin/steam)
STEAM_TERMINAL := $(shell command -v gnome-terminal \
	|| command -v xterm \
	|| command -v konsole \
	|| command -v x-terminal-emulator \
	|| echo /usr/bin/gnome-terminal)

SOFTWARE_PROPERTIES_COMMON := $(shell command -v add-apt-repository || echo /usr/bin/add-apt-repository)
LUTRIS := $(shell command -v lutris || echo /usr/games/lutris)

EPIC_GAMES_STORE := $(shell echo "$$HOME/Games/epic-games-store/drive_c/Program\ Files*/Epic\ Games/Launcher/Engine/Binaries/Win*/EpicGamesLauncher.exe")

RETROARCH := $(shell command -v retroarch || echo /usr/bin/retroarch)

SLACK := $(shell command -v slack || echo /usr/bin/slack)

TEAMVIEWER := $(shell command -v teamviewer || echo /usr/bin/teamviewer)

LSB_RELEASE := $(shell command -v lsb_release || echo /usr/bin/lsb_release)

NPM := $(shell command -v npm || echo /usr/bin/npm)
NODE := $(shell command -v node || echo /usr/bin/node)

DOCKER := $(shell command -v docker || echo /usr/bin/docker)
DOCKER_CONFIG := $(shell echo "$$HOME/.docker/config.json")

DOCKER_COMPOSE := $(shell command -v docker-compose || echo /usr/local/bin/docker-compose)

DOCKER_COMPOSE_DEVELOPMENT := $(shell echo "$(GITPROJECTS)/development")
DOCKER_COMPOSE_DEVELOPMENT_PROFILE := $(shell echo "$$HOME/.zshrc-development")

ZSH := $(shell command -v zsh || echo /usr/bin/zsh)
ZSHRC := $(shell echo "$$HOME/.zshrc")
OH_MY_ZSH := $(shell echo "$$HOME/.oh-my-zsh/oh-my-zsh.sh")

JQ := $(shell command -v jq || echo /usr/bin/jq)
CURL := $(shell command -v curl || echo /usr/bin/curl)
GIT := $(shell command -v git || echo /usr/bin/git)
BASH := $(shell command -v bash || echo /bin/bash)
VIM := $(shell command -v vim || echo /usr/bin/vim)

install: | \
	$(CHROME) \
	$(GITCONFIG_USER) \
	$(ZSHRC) \
	$(OH_MY_ZSH) \
	$(DOCKER_CONFIG) \
	$(JETBRAINS_TOOLBOX_SETTINGS)

$(GITCONFIG):
	ln -s "$(shell pwd)/.gitconfig" "$(GITCONFIG)"

gitconfig: | $(GITCONFIG)

$(GITIGNORE):
	ln -s "$(shell pwd)/.gitignore" "$(GITIGNORE)"

gitignore: | $(GITIGNORE)

$(GITPROJECTS):
	mkdir -p "$(GITPROJECTS)"

$(VIM):
	sudo apt install vim -y

vim: | $(VIM)

$(GIT): | $(GITCONFIG) $(GITIGNORE) $(GITPROJECTS) $(VIM)
	sudo apt install git -y

$(GITCONFIG_USER): | $(GIT) $(GITCONFIG)
	@echo $(INTERACTIVE) | grep -q '1' \
			&& read -p 'Git user name: ' username \
			|| username="$(shell whoami)"; \
		$(GIT) config --file $(GITCONFIG_USER) user.name "$$username"
	@echo $(INTERACTIVE) | grep -q '1' \
			&& read -p 'Git user email: ' email \
			|| email="$(shell whoami)@$(shell hostname)"; \
		$(GIT) config --file $(GITCONFIG_USER) user.email "$$email"

gitconfig-user: | $(GITCONFIG_USER)

git: | $(GIT) $(GITCONFIG_USER)

$(JQ):
	sudo apt install jq -y

jq: | $(JQ)

$(CURL):
	sudo apt install curl -y

curl: | $(CURL)

$(JETBRAINS_TOOLBOX): | $(JQ) $(CURL)
	$(CURL) -L --output - $(shell $(CURL) 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | $(JQ) '.TBA[0].downloads.linux.link' | sed 's/"//g') | tar zxf - -C /tmp
	sudo mv /tmp/jetbrains-toolbox-*/jetbrains-toolbox $(JETBRAINS_TOOLBOX)

$(JETBRAINS_TOOLBOX_SETTINGS): | $(JETBRAINS_TOOLBOX)
	mkdir -p $(shell dirname $(JETBRAINS_TOOLBOX_SETTINGS))
	echo $(INTERACTIVE) | grep -q '1' && $(JETBRAINS_TOOLBOX) || echo '{}' > $(JETBRAINS_TOOLBOX_SETTINGS)

jetbrains-toolbox: $(JETBRAINS_TOOLBOX_SETTINGS)

$(LSB_RELEASE):
	sudo apt install lsb-release -y

lsb_release: $(LSB_RELEASE)

$(DOCKER): | $(LSB_RELEASE) $(CURL)
	sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
	$(CURL) -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(shell $(LSB_RELEASE) -cs) stable"
	sudo apt update -y
	sudo apt install docker-ce docker-ce-cli containerd.io -y
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
			| jq '.assets[] | select(.name == "docker-compose-Linux-x86_64").browser_download_url' \
			| sed 's/"//g') \
		--output $(DOCKER_COMPOSE)
	sudo chmod +x $(DOCKER_COMPOSE)

docker-compose: | $(DOCKER_COMPOSE)

$(DOCKER_COMPOSE_DEVELOPMENT): | $(DOCKER) $(DOCKER_COMPOSE) $(DOCKER_CONFIG) $(GIT) $(GITPROJECTS)
	$(GIT) clone git@github.com:JeroenBoersma/docker-compose-development.git $(DOCKER_COMPOSE_DEVELOPMENT)
	sudo service docker start
	for volume in $(shell $(DOCKER) volume ls -q | grep dockerdev-); do \
		for container in $(shell $(DOCKER) ps -a --filter volume=$$volume | tail -n +2); do \
			$(DOCKER) rm $$container;\
		done; \
		$(DOCKER) volume rm $$volume; \
	done
	"$(DOCKER_COMPOSE_DEVELOPMENT)/bin/dev" setup

$(DOCKER_COMPOSE_DEVELOPMENT_PROFILE): | $(DOCKER_COMPOSE_DEVELOPMENT) $(ZSHRC)
	"$(DOCKER_COMPOSE_DEVELOPMENT)/bin/dev" profile > $(DOCKER_COMPOSE_DEVELOPMENT_PROFILE)

docker-compose-development: | $(DOCKER_COMPOSE_DEVELOPMENT_PROFILE)

$(ZSH):
	sudo apt install zsh -y
	echo $(INTERACTIVE) | grep -q '1' && chsh --shell $(ZSH) || echo 'Skipping shell change'

$(ZSHRC):
	ln -s "$(shell pwd)/.zshrc" "$(ZSHRC)"

zsh: | $(ZSH) $(ZSHRC)

$(BASH):
	sudo apt install bash -y

bash: | $(BASH)

$(OH_MY_ZSH): | $(ZSH) $(CURL) $(BASH) $(GIT)
	$(CURL) -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
		| ZSH=$(shell dirname $(OH_MY_ZSH)) $(BASH) -s -- --keep-zshrc --unattended

oh-my-zsh: | $(OH_MY_ZSH)

$(CHROME): | $(CURL)
	sudo apt install -y \
		fonts-liberation \
		libasound2 \
		libatk-bridge2.0-0 \
		libatk1.0-0 \
		libatspi2.0-0 \
		libcairo2 \
		libcups2 \
		libdbus-1-3 \
		libdrm2 \
		libexpat1 \
		libgbm1 \
		libgdk-pixbuf2.0-0 \
		libglib2.0-0 \
		libgtk-3-0 \
		libnspr4 \
		libnss3 \
		libpango-1.0-0 \
		libpangocairo-1.0-0 \
		libx11-6 \
		libx11-xcb1 \
		libxcb-dri3-0 \
		libxcb1 \
		libxcomposite1 \
		libxdamage1 \
		libxext6 \
		libxfixes3 \
		libxrandr2 \
		wget \
		xdg-utils
	$(CURL) -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    		--output /tmp/google-chrome-stable_current_amd64.deb
	sudo dpkg --install /tmp/google-chrome-stable_current_amd64.deb
	rm -f /tmp/google-chrome-stable_current_amd64.deb

google-chrome: | $(CHROME)

optional: | \
	discord \
	docker-compose \
	docker-compose-development \
	epic-games-store \
	gimp \
	lutris \
	node \
	retroarch \
	slack \
	steam \
	teamviewer \
	transmission-remote

$(TRANSMISSION_REMOTE):
	sudo apt install transmission-remote-gtk -y

transmission-remote: | $(TRANSMISSION_REMOTE)

$(GIMP):
	sudo apt install gimp -y

gimp: | $(GIMP)

$(STEAM_TERMINAL):
	sudo apt install gnome-terminal -y

$(ZENITY):
	sudo apt install zenity -y

$(STEAM): | $(CURL) $(STEAM_TERMINAL) $(ZENITY)
	# See: https://github.com/ValveSoftware/steam-for-linux/issues/7067#issuecomment-622390607
	echo $(LIB_NVIDIA_GL) | grep -q ':amd64' \
		&& sudo apt install $(shell echo $(LIB_NVIDIA_GL) | cut -d: -f1):i386 python3-apt -y \
		|| sudo apt install python3-apt -y
	rm -rf $$HOME/.steam
	$(CURL) -L https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb \
		--output /tmp/steam.deb
	sudo dpkg --install /tmp/steam.deb
	rm -f /tmp/steam.deb
	sudo dpkg --add-architecture i386
	sudo apt update -y
	sudo apt install libgl1-mesa-dri:i386 libgl1:i386 libc6:i386 -y -o APT::Immediate-Configure=false -f
	sudo dpkg --configure -a

steam: | $(STEAM)

$(SLACK): | $(CURL)
	sudo apt install libgtk-3-0 libappindicator3-1 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 -y
	sudo dpkg --list | awk '{ print $2 }' | grep -qE 'kde-cli-tools|kde-runtime|trash-cli|libglib2.0-bin|gvfs-bin' \
		|| sudo apt install gvfs-bin -y
	$(CURL) -L $(shell $(CURL) -L https://slack.com/intl/en-nl/downloads/instructions/ubuntu \
			| grep -oe 'https://downloads.slack-edge.com/linux_releases/slack-desktop-[0-9]*.[0-9]*.[0-9]*-amd64.deb') \
		--output /tmp/slack.deb
	sudo dpkg --install /tmp/slack.deb
	rm -f /tmp/slack.deb

slack: | $(SLACK)

$(DISCORD): | $(CURL)
	sudo apt install -y \
		libasound2 \
		libgconf-2-4 \
		libnotify4 \
		libnspr4 \
		libnss3 \
		libxss1 \
		libxtst6 \
		libappindicator1 \
		libc++1
	$(CURL) -L 'https://discord.com/api/download?platform=linux&format=deb' \
		--output /tmp/discord.deb
	sudo dpkg --install /tmp/discord.deb
	rm -f /tmp/discord.deb

discord: | $(DISCORD)

$(SOFTWARE_PROPERTIES_COMMON):
	sudo apt install software-properties-common -y

$(LUTRIS): | $(SOFTWARE_PROPERTIES_COMMON)
	sudo add-apt-repository ppa:lutris-team/lutris -y
	sudo apt update -y
	sudo apt install lutris -y

lutris: | $(LUTRIS)

$(EPIC_GAMES_STORE): | $(LUTRIS)
	echo $(INTERACTIVE) | grep -q '1' \
		&& $(LUTRIS) --install 'https://lutris.net/api/installers/epic-games-store-latest?format=json' \
		|| echo 'Lutris currently does not support unattended installations. See https://github.com/lutris/lutris/pull/3029'

epic-games-store: | $(EPIC_GAMES_STORE)

$(RETROARCH): | $(SOFTWARE_PROPERTIES_COMMON)
	sudo add-apt-repository ppa:libretro/stable -y
	sudo apt-get update -y
	sudo apt-get install retroarch* -y

retroarch: | $(RETROARCH)

$(TEAMVIEWER): | $(CURL)
	sudo apt install -y \
		libqt5qml5 \
		libqt5quick5 \
		libqt5webkit5 \
		libqt5x11extras5 \
		qml-module-qtquick2 \
		qml-module-qtquick-controls \
		qml-module-qtquick-dialogs \
		qml-module-qtquick-window2 \
		qml-module-qtquick-layouts
	$(CURL) -L https://download.teamviewer.com/download/linux/teamviewer_amd64.deb \
		--output /tmp/teamviewer.deb
	sudo dpkg --install /tmp/teamviewer.deb
	rm -f /tmp/teamviewer.deb

teamviewer: | $(TEAMVIEWER)

$(NODE): | $(CURL) $(BASH)
	$(CURL) -sL https://deb.nodesource.com/setup_current.x | sudo -E $(BASH) -
	sudo apt update
	sudo apt install -y nodejs

node: | $(NODE)

$(NPM): | $(NODE)
npm: | $(NPM)

all: | install optional
