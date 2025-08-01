$(GEDIT):
	sudo apt install gedit -y

gedit: | $(GEDIT)

install:: | gedit
