$(FIREFOX):
	sudo apt install -y firefox

firefox: | $(FIREFOX)

browsers:: | firefox
optional:: | firefox
