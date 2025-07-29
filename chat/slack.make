$(SLACK): | $(CURL)
	sudo apt install libgtk-3-0 libappindicator3-1 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 -y
	sudo dpkg --list | awk '{ print $2 }' | grep -qE 'kde-cli-tools|kde-runtime|trash-cli|libglib2.0-bin|gvfs-bin' \
		|| sudo apt install gvfs-bin -y
	SLACK_URL=$(shell $(CURL) -L https://slack.com/intl/en-nl/downloads/instructions/ubuntu \
         | grep -oe 'https://downloads.slack-edge.com/desktop-releases/linux/x64/[0-9]*\.[0-9]*\.[0-9]*/slack-desktop-[0-9]*\.[0-9]*\.[0-9]*-amd64.deb')
	  if [ -z "$SLACK_URL" ]; then
		echo "Failed to retrieve Slack URL"
		exit 1
	  fi
     $(CURL) -L $SLACK_URL --output /tmp/slack.deb
	sudo dpkg --install /tmp/slack.deb
	rm -f /tmp/slack.deb

slack: | $(SLACK)

install:: | slack
