GIT := $(shell command -v git || echo /usr/bin/git)
GITCONFIG_USER := $(shell echo "$$HOME/.gitconfig-user")
GITCONFIG := $(shell echo "$$HOME/.gitconfig")
GITIGNORE := $(shell echo "$$HOME/.gitignore")
GITPROJECTS := $(shell echo "$$HOME/git")
GITDOMAINS = github.com gist.github.com gitlab.elgentos.nl
