INTERACTIVE=1

# Use systemctl, or a dummy.
SYSTEMCTL := $(shell command -v systemctl || echo echo systemctl)

GITCONFIG_USER := $(shell echo "$$HOME/.gitconfig-user")
GITCONFIG := $(shell echo "$$HOME/.gitconfig")
GITIGNORE := $(shell echo "$$HOME/.gitignore")
GITPROJECTS := $(shell echo "$$HOME/git")

SSH := $(shell command -v ssh || /usr/bin/ssh)
SSH_KEY := $(shell echo "$$HOME/.ssh/id_rsa")

JETBRAINS_TOOLBOX := $(shell command -v jetbrains-toolbox || echo /usr/local/bin/jetbrains-toolbox)
JETBRAINS_TOOLBOX_SETTINGS := $(shell echo "$$HOME/.local/share/JetBrains/Toolbox/.settings.json")

BRAVE := $(shell command -v brave-browser || echo /usr/bin/brave-browser)
CHROME := $(shell command -v google-chrome || echo /usr/bin/google-chrome)
FIREFOX := $(shell command -v firefox || echo /usr/bin/firefox)

SOFTWARE_PROPERTIES_COMMON := $(shell command -v add-apt-repository || echo /usr/bin/add-apt-repository)

SLACK := $(shell command -v slack || echo /usr/bin/slack)

LSB_RELEASE := $(shell command -v lsb_release || echo /usr/bin/lsb_release)

NPM := $(shell command -v npm || echo "$$HOME/.nvm/versions/node/v*.*.*/bin/npm")
NODE := $(shell command -v node || echo "$$HOME/.nvm/versions/node/v*.*.*/bin/node")
NVM := $(shell command -v nvm || echo "$$HOME/.nvm/nvm.sh")

DOCKER := $(shell command -v docker || echo /usr/bin/docker)
DOCKER_CONFIG := $(shell echo "$$HOME/.docker/config.json")
DOCKER_COMPOSE := $(shell command -v docker-compose || echo /usr/local/bin/docker-compose)

DNSMASQ = /etc/dnsmasq.d

DOCKER_COMPOSE_DEVELOPMENT := $(shell echo "$$HOME/development")
DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE := $(shell dev workspace 2>/dev/null || echo "$(DOCKER_COMPOSE_DEVELOPMENT)/workspace")
DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN = $(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE)/bin
DOCKER_COMPOSE_DEVELOPMENT_PROFILE := $(shell echo "$$HOME/.zshrc-development")
DOCKER_COMPOSE_DEVELOPMENT_DNSMASQ := $(shell echo "$(DNSMASQ)/docker-compose-development.conf")

COMPOSER := $(shell command -v composer || echo "$(DOCKER_COMPOSE_DEVELOPMENT)/bin/composer")
COMPOSER_LOCK_DIFF := $(shell command -v composer-lock-diff || echo /usr/local/bin/composer-lock-diff)
COMPOSER_CHANGELOGS := $(shell command -v composer-changelogs || echo /usr/local/bin/composer-changelogs)

ZSH := $(shell command -v zsh || echo /usr/bin/zsh)
ZSHRC := $(shell echo "$$HOME/.zshrc")
OH_MY_ZSH := $(shell echo "$$HOME/.oh-my-zsh/oh-my-zsh.sh")

AG := $(shell command -v ag || echo /usr/bin/ag)
JQ := $(shell command -v jq || echo /usr/bin/jq)
CURL := $(shell command -v curl || echo /usr/bin/curl)
GIT := $(shell command -v git || echo /usr/bin/git)
BASH := $(shell command -v bash || echo /bin/bash)
VIM := $(shell command -v vim || echo /usr/bin/vim)

UFW := $(shell command -v ufw || echo /usr/sbin/ufw)
IP := $(shell command -v ip || echo /usr/sbin/ip)

AWS := $(shell command -v aws || echo /usr/local/bin/aws)
SSG := $(shell command -v ssg || echo /usr/bin/ssg)

SYMLINKS := $(shell command -v symlinks || echo /usr/bin/symlinks)
TMUX := $(shell command -v tmux || echo /usr/bin/tmux)
TMUXINATOR := $(shell command -v tmuxinator || echo /usr/bin/tmuxinator)
TMUXINATOR_COMPLETION_ZSH = /usr/local/share/zsh/site-functions/_tmuxinator
TMUXINATOR_COMPLETION_BASH = /etc/bash_completion.d/tmuxinator.bash
GIMP := $(shell command -v gimp || echo /usr/bin/gimp)

install: | \
	$(GITCONFIG_USER) \
	$(SSH_KEY) \
	$(ZSHRC) \
	$(OH_MY_ZSH) \
	$(DOCKER_COMPOSE_DEVELOPMENT_PROFILE) \
	$(DOCKER_COMPOSE_DEVELOPMENT_DNSMASQ) \
	$(NODE) \
	$(AWS) \
	$(SLACK) \
	$(JETBRAINS_TOOLBOX_SETTINGS)

$(UFW): | $(BASH)
	sudo apt install -y ufw
	$(BASH) -c '[ -f /.dockerenv ] || sudo ufw enable'

ufw: | $(UFW)

$(IP):
	sudo apt install -y iproute2

ip: $(IP)

$(GITCONFIG):
	cp "$(shell pwd)/.gitconfig" "$(GITCONFIG)"

gitconfig: | $(GITCONFIG)

$(GITIGNORE):
	cp "$(shell pwd)/.gitignore" "$(GITIGNORE)"

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

$(DOCKER_COMPOSE_DEVELOPMENT): | $(DOCKER) $(DOCKER_COMPOSE) $(DOCKER_CONFIG) $(GIT) $(GITPROJECTS) $(UFW) $(IP) $(SSH_KEY)
	$(GIT) clone git@github.com:JeroenBoersma/docker-compose-development.git $(DOCKER_COMPOSE_DEVELOPMENT)
	sudo service docker start
	for volume in $(shell $(DOCKER) volume ls -q | grep dockerdev-); do \
		for container in `$(DOCKER) ps -aq --filter volume=$$volume`; do \
			$(DOCKER) rm $$container;\
		done; \
		$(DOCKER) volume rm $$volume; \
	done
	for iface in $(shell $(IP) route | grep -Eo 'docker[0-9]' | uniq); do \
		sudo $(UFW) allow in on "$$iface" to any port 80 proto tcp; \
		sudo $(UFW) allow in on "$$iface" to any port 443 proto tcp; \
		sudo $(UFW) allow in on "$$iface" to any port 9000 proto tcp; \
	done
	echo $(INTERACTIVE) | grep -q '1' \
		&& "$(DOCKER_COMPOSE_DEVELOPMENT)/bin/dev" setup \
		|| DOMAINSUFFIX=.localhost echo php80 \
			| "$(DOCKER_COMPOSE_DEVELOPMENT)/bin/dev" setup

$(DOCKER_COMPOSE_DEVELOPMENT_PROFILE): | $(DOCKER_COMPOSE_DEVELOPMENT) $(ZSHRC)
	"$(DOCKER_COMPOSE_DEVELOPMENT)/bin/dev" profile > $(DOCKER_COMPOSE_DEVELOPMENT_PROFILE)
	echo 'for ws in "$$($(DOCKER_COMPOSE_DEVELOPMENT)/bin/dev workspace)"/*; do hash -d "$$(basename "$$ws")=$$ws"; done' \
		>> $(DOCKER_COMPOSE_DEVELOPMENT_PROFILE)

docker-compose-development: | $(DOCKER_COMPOSE_DEVELOPMENT_PROFILE)

$(ZSH):
	sudo apt install zsh -y
	echo $(INTERACTIVE) | grep -q '1' && chsh --shell $(ZSH) || echo 'Skipping shell change'

$(ZSHRC):
	cp "$(shell pwd)/.zshrc" "$(ZSHRC)"

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

$(SOFTWARE_PROPERTIES_COMMON):
	sudo apt install software-properties-common -y

$(NVM): | $(CURL) $(BASH) $(ZSHRC)
	$(CURL) -sf https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | $(BASH)
	echo 'export NVM_DIR="$$HOME/.nvm"' >> $(ZSHRC)
	echo '[ -s "$$NVM_DIR/nvm.sh" ] && \. "$$NVM_DIR/nvm.sh"  # This loads nvm' >> $(ZSHRC)
	echo '[ -s "$$NVM_DIR/bash_completion" ] && \. "$$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> $(ZSHRC)

$(NODE): | $(NVM) $(BASH)
	$(BASH) -c 'source $(NVM) && nvm install 10'

node: | $(NODE)

$(NPM): | $(NODE)
npm: | $(NPM)

$(BRAVE): | $(CURL)
	sudo apt install -y apt-transport-https curl gnupg
	$(CURL) -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc \
		| sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
	echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
		| sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update -y
	sudo apt install -y brave-browser

brave: | $(BRAVE)

$(FIREFOX):
	sudo apt install -y firefox

firefox: | $(FIREFOX)

$(DNSMASQ): | $(BASH) $(UFW)
	$(BASH) -c '[ -f /.dockerenv ] || sudo $(SYSTEMCTL) disable --now systemd-resolved'
	$(BASH) -c '[ -f /.dockerenv ] || sudo rm -f /etc/resolv.conf'
	echo 'nameserver 127.0.0.1' | sudo tee    /etc/resolv.conf
	echo 'nameserver 1.1.1.1'   | sudo tee -a /etc/resolv.conf
	echo 'nameserver 9.9.9.9'   | sudo tee -a /etc/resolv.conf
	sudo mkdir -p /etc/NetworkManager/conf.d
	echo "[main]\ndns=none\nrc-manager=unmanaged" | sudo tee /etc/NetworkManager/conf.d/dnsmasq.conf
	sudo service --status-all \
		| awk '{ print $$4 }' \
		| grep -q network-manager \
			&& sudo service network-manager restart \
			|| echo 'Skipping NetworkManager restart.'
	sleep 2
	for con in $(shell nmcli con show --active | tail -n +2 | awk '{ print $$1 }'); do \
		nmcli con mod "$$con" ipv4.ignore-auto-dns yes; \
		nmcli con mod "$$con" ipv4.dns '127.0.0.1 1.1.1.1 9.9.9.9'; \
		nmcli con down "$$con"; \
		nmcli con up "$$con"; \
		sudo nmcli con reload; \
	done
	sudo $(UFW) allow out to 1.1.1.1 port 53 proto udp;
	sudo $(UFW) allow out to 9.9.9.9 port 53 proto udp;
	sudo apt install -y dnsmasq
	sudo rm -f /etc/dnsmasq.conf
	echo port=53                  | sudo tee    /etc/dnsmasq.conf
	echo domain-needed            | sudo tee -a /etc/dnsmasq.conf
	echo expand-hosts             | sudo tee -a /etc/dnsmasq.conf
	echo bogus-priv               | sudo tee -a /etc/dnsmasq.conf
	echo listen-address=127.0.0.1 | sudo tee -a /etc/dnsmasq.conf
	echo cache-size=1000          | sudo tee -a /etc/dnsmasq.conf
	dnsmasq --test
	sudo mkdir -p "$(DNSMASQ)"
	$(BASH) -c '[ -f /.dockerenv ] || sudo service dnsmasq restart'

dnsmasq: | $(DNSMASQ)

$(DOCKER_COMPOSE_DEVELOPMENT_DNSMASQ): $(DNSMASQ) | $(DOCKER_COMPOSE_DEVELOPMENT_PROFILE) $(BASH) $(UFW) $(IP)
	$(DOCKER_COMPOSE_DEVELOPMENT)/bin/dev down
	$(BASH) -c '[ -f /.dockerenv ] || sudo rm -f /etc/resolv.conf'
	sudo touch /etc/resolv.conf
	DOCKER_GATEWAY="$(shell $(IP) route | grep -E 'docker[0-9]' | awk '{ print $$9 }' | grep '.')" \
		&& $(BASH) -c \
			'source "$(DOCKER_COMPOSE_DEVELOPMENT)/.env" && echo "address=/$$DOMAINSUFFIX/'$${$DOCKER_GATEWAY:-127.0.0.1}'"' \
		| sudo tee $(DOCKER_COMPOSE_DEVELOPMENT_DNSMASQ) \
		&& echo nameserver $${$DOCKER_GATEWAY:-127.0.0.1} | sudo tee -a /etc/resolv.conf \
		&& cat /etc/dnsmasq.conf \
			| sed -E 's/listen-address=.+/listen-address='$${$DOCKER_GATEWAY:-127.0.0.1}'/' \
			| sudo tee /etc/dnsmasq.conf
	echo nameserver 127.0.0.1 | sudo tee -a /etc/resolv.conf
	echo nameserver 1.1.1.1   | sudo tee -a /etc/resolv.conf
	echo nameserver 9.9.9.9   | sudo tee -a /etc/resolv.conf
	for con in $(shell nmcli con show --active | tail -n +2 | awk '{ print $$1 }'); do \
		nmcli con mod "$$con" ipv4.dns "$(shell $(IP) route | grep -E 'docker[0-9]' | awk '{ print $$9 }' | grep '.') 127.0.0.1 1.1.1.1 9.9.9.9"; \
		nmcli con down "$$con"; \
		nmcli con up "$$con"; \
		sudo nmcli con reload; \
	done
	for iface in $(shell $(IP) route | grep -Eo 'docker[0-9]' | uniq); do \
		sudo $(UFW) allow in on "$$iface" to any port 53 proto udp; \
	done
	cat /etc/dnsmasq.conf
	dnsmasq --test
	$(BASH) -c '[ -f /.dockerenv ] || sudo service dnsmasq restart'
	sudo service docker restart
	$(BASH) -c 'source "$(DOCKER_COMPOSE_DEVELOPMENT)/.env" && sudo $(DOCKER) run --rm -t tutum/dnsutils dig setup$$DOMAINSUFFIX +short'

docker-compose-development-dnsmasq: | $(DOCKER_COMPOSE_DEVELOPMENT_DNSMASQ)

$(AWS): | git $(DOCKER) $(SSH_KEY)
	$(GIT) clone \
		git@gist.github.com:87e29fd4aa06ec42216c80a6e3649fa5.git \
		$(GITPROJECTS)/aws-cli
	chmod +x $(GITPROJECTS)/aws-cli/aws.sh
	sudo ln -s $(GITPROJECTS)/aws-cli/aws.sh $(AWS)
	@echo $(INTERACTIVE) | grep -q '1' && sudo $(AWS) --version || echo -n ''

aws: | $(AWS)

$(SSG): | git $(NPM) $(NVM) $(BASH) $(SSH_KEY)
	$(GIT) clone git@github.com:elgentos/ssg-js.git $(GITPROJECTS)/ssg-js
	cd $(GITPROJECTS)/ssg-js \
		&& 		$(BASH) -c "source $(NVM) && npm install" \
		&& sudo $(BASH) -c "source $(NVM) && npm install -g ssg-js"

ssg: | $(SSG)

$(SYMLINKS):
	sudo apt install -y symlinks

symlinks: | $(SYMLINKS)

$(TMUX):
	sudo apt install -y tmux

tmux: | $(TMUX)

$(TMUXINATOR): | $(TMUX)
	sudo apt install -y tmuxinator

tmuxinator: | $(TMUXINATOR)

$(TMUXINATOR_COMPLETION_ZSH): | $(TMUXINATOR) $(ZSH) $(CURL)
	sudo mkdir -p "$(shell dirname "$(TMUXINATOR_COMPLETION_ZSH)")";
	$(CURL) -L https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh \
		| sudo tee $(TMUXINATOR_COMPLETION_ZSH)

$(TMUXINATOR_COMPLETION_BASH): | $(TMUXINATOR) $(BASH) $(CURL)
	sudo mkdir -p "$(shell dirname "$(TMUXINATOR_COMPLETION_BASH)")";
	$(CURL) -L https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.bash \
		| sudo tee $(TMUXINATOR_COMPLETION_BASH)

tmuxinator_completion: | $(TMUXINATOR_COMPLETION_ZSH) $(TMUXINATOR_COMPLETION_BASH)

all: | \
	install \
	brave \
	composer-lock-diff \
	composer-changelogs \
	firefox \
	gimp \
	google-chrome \
	symlinks \
	ssg \
	tmuxinator_completion

$(SSH): | $(GIT)

ssh: | $(SSH)

$(SSH_KEY): | $(SSH)
	mkdir -p "$(shell dirname "$(SSH_KEY)")"
	ssh-keygen \
		-t rsa \
		-b 4096 \
		-C $$USER@elgentos.nl \
		-f "$(SSH_KEY)"
	ssh-add "$(SSH_KEY)"
	cat "$(SSH_KEY).pub"

ssh-key: | $(SSH_KEY)

$(GIMP):
	sudo apt install gimp -y

gimp: | $(GIMP)

$(COMPOSER): | $(DOCKER_COMPOSE_DEVELOPMENT)
composer: | $(COMPOSER)

$(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN): $(DOCKER_COMPOSE_DEVELOPMENT)
	mkdir -p "$(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)"

$(COMPOSER_LOCK_DIFF): | $(COMPOSER) $(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)
	$(COMPOSER) global require davidrjonas/composer-lock-diff
	echo '$(COMPOSER) global exec -- composer-lock-diff $$@;\nexit $$?;' > "$(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)/composer-lock-diff"
	sudo ln -s "$(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)/composer-lock-diff" "$(COMPOSER_LOCK_DIFF)"
	sudo chmod +x $(COMPOSER_LOCK_DIFF)

composer-lock-diff: | $(COMPOSER_LOCK_DIFF)

$(COMPOSER_CHANGELOGS): | $(COMPOSER) $(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)
	$(COMPOSER) global require pyrech/composer-changelogs
	echo '$(COMPOSER) global exec -- composer-changelogs $$@;\nexit $$?;' > "$(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)/composer-changelogs"
	sudo ln -s "$(DOCKER_COMPOSE_DEVELOPMENT_WORKSPACE_BIN)/composer-changelogs" "$(COMPOSER_CHANGELOGS)"
	sudo chmod +x $(COMPOSER_CHANGELOGS)

composer-changelogs: | $(COMPOSER_CHANGELOGS)

$(AG):
	sudo apt install silversearcher-ag -y

ag: | $(AG)
