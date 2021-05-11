GIT := $(shell command -v git || echo /usr/bin/git)
GITCONFIG_USER := $(shell echo "$$HOME/.gitconfig-user")
GITCONFIG := $(shell echo "$$HOME/.gitconfig")
GITIGNORE := $(shell echo "$$HOME/.gitignore")
GITPROJECTS := $(shell echo "$$HOME/git")

$(GITCONFIG):
	cp "$(shell pwd)/.gitconfig" "$(GITCONFIG)"

gitconfig: | $(GITCONFIG)

$(GITIGNORE):
	cp "$(shell pwd)/.gitignore" "$(GITIGNORE)"

gitignore: | $(GITIGNORE)

$(GITPROJECTS):
	mkdir -p "$(GITPROJECTS)"

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

install:: | git
