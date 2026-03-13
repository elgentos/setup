$(SLACK):
	sudo snap install slack

slack: | $(SLACK)

install:: | slack
