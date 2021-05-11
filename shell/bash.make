BASH := $(shell command -v bash || echo /bin/bash)

$(BASH):
	sudo apt install bash -y

bash: | $(BASH)
