FIREFOX := $(shell command -v firefox || echo /usr/bin/firefox)

$(FIREFOX):
	sudo apt install -y firefox

firefox: | $(FIREFOX)

browsers:: | firefox
optional:: | firefox
