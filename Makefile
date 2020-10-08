GITCONFIG := $(shell echo "$$HOME/.gitconfig")
GITPROJECTS := $(shell echo "$$HOME/git")

JETBRAINS_TOOLBOX := $(shell command -v jetbrains-toolbox || echo /usr/local/bin/jetbrains-toolbox)
JETBRAINS_TOOLBOX_SETTINGS := $(shell echo "$$HOME/.local/share/JetBrains/Toolbox/.settings.json")

JQ := $(shell command -v jq || echo /usr/bin/jq)
CURL := $(shell command -v curl || echo /usr/bin/curl)
GIT := $(shell command -v git || echo /usr/bin/git)

install: \
	$(GIT) \
	$(JETBRAINS_TOOLBOX_SETTINGS)

$(GITCONFIG):
	ln -s "$(shell pwd)/.gitconfig" "$(GITCONFIG)"

$(GITPROJECTS):
	mkdir -p "$(GITPROJECTS)"

$(GIT): $(GITCONFIG) $(GITPROJECTS)
	sudo apt install git -y

$(JQ):
	sudo apt install jq -y

$(CURL):
	sudo apt install curl -y

$(JETBRAINS_TOOLBOX): $(JQ) $(CURL)
	$(CURL) -L --output - $(shell $(CURL) 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | $(JQ) '.TBA[0].downloads.linux.link' | sed 's/"//g') | tar zxf - -C /tmp
	sudo mv /tmp/jetbrains-toolbox-*/jetbrains-toolbox $(JETBRAINS_TOOLBOX)

$(JETBRAINS_TOOLBOX_SETTINGS): $(JETBRAINS_TOOLBOX)
	$(JETBRAINS_TOOLBOX)
	

