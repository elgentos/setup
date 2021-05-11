JQ := $(shell command -v jq || echo /usr/bin/jq)

$(JQ):
	sudo apt install jq -y

jq: | $(JQ)
