
$(BRAVE): | $(CURL)
	sudo apt install -y apt-transport-https curl gnupg
	sudo install -m 0755 -d /etc/apt/keyrings
	$(CURL) -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc -o /tmp/brave-core.asc
	sudo gpg --dearmor -o /etc/apt/keyrings/brave-browser-release.gpg /tmp/brave-core.asc
	sudo chmod a+r /etc/apt/keyrings/brave-browser-release.gpg
	echo "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/brave-browser-release.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
		| sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null
	sudo apt update -y
	sudo apt install -y brave-browser

brave: | $(BRAVE)

browsers:: | brave
optional:: | brave
