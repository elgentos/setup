$(JQ):
	sudo apt install jq -y

jq: | $(JQ)
