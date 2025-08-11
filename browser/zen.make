$(ZEN): | $(CURL)
	$(CURL) -L $(shell $(CURL) -L 'https://zen-browser.app/download/' \
			| grep -oE 'https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz') \
		--output /tmp/zen.tar.xz
	sudo tar -xf /tmp/zen.tar.xz -C /opt
	sudo ln -s /opt/zen/zen /usr/bin/zen
	sudo mkdir -p /usr/local/share/applications
	sudo cp ./browser/desktop/zen.desktop /usr/local/share/applications/zen.desktop
	rm /tmp/zen.tar.xz

	# make 1password interact with zen browser
	sudo mkdir -p /etc/1password
	sudo touch /etc/1password/custom_allowed_browsers
	echo "zen" | sudo tee -a /etc/1password/custom_allowed_browsers

zen: | $(ZEN)

browsers:: | zen
optional:: | zen