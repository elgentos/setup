CURL := $(shell command -v curl || echo /usr/bin/curl)

$(CURL):
	sudo apt install curl -y

curl: | $(CURL)
