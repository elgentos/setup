$(SLACK): | $(CURL)
	$(CURL) -L $(shell $(CURL) -L 'https://slack.com/downloads/instructions/linux?ddl=1&build=deb' \
			| grep -oE 'https://downloads.slack-edge.com/desktop-releases/linux/x64/[0-9]+\.[0-9]+\.[0-9]+/slack-desktop-[0-9]+\.[0-9]+\.[0-9]+-amd64.deb') \
		--output /tmp/slack.deb
	sudo dpkg --install /tmp/slack.deb || true
	rm -f /tmp/slack.deb

slack: | $(SLACK)

install:: | slack
