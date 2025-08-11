$(SLACK): | $(CURL)
	sudo apt update -y
	sudo apt install libgtk-3-0 libappindicator3-1 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 kde-cli-tools -y
	$(CURL) -L $(shell $(CURL) -L 'https://slack.com/downloads/instructions/linux?build=deb' \
			| grep -oE 'https://downloads\.slack-edge\.com/desktop-releases/linux/x64/[0-9]+\.[0-9]+\.[0-9]+/slack-desktop-[0-9]+\.[0-9]+\.[0-9]+-amd64\.deb') \
		--output /tmp/slack.deb
	sudo dpkg --install /tmp/slack.deb || true
	rm -f /tmp/slack.deb

slack: | $(SLACK)

install:: | slack
