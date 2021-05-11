BRAVE := $(shell command -v brave-browser || echo /usr/bin/brave-browser)

$(BRAVE): | $(CURL)
	sudo apt install -y apt-transport-https curl gnupg
	$(CURL) -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc \
		| sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
	echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
		| sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update -y
	sudo apt install -y brave-browser

brave: | $(BRAVE)

browsers:: | brave
optional:: | brave
