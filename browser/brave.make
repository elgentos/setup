
$(BRAVE): | $(CURL)
	sudo apt install -y apt-transport-https curl gnupg
	sudo $(CURL) -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	sudo $(CURL) -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
	sudo apt update -y
	sudo apt install -y brave-browser

brave: | $(BRAVE)

browsers:: | brave
optional:: | brave
