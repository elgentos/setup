$(CURL):
	sudo apt install curl -y

curl: | $(CURL)
