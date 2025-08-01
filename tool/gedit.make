$(GEDIT):
	sudo apt update
	sudo apt install gedit -y

gedit: | $(GEDIT)

optional:: | gedit
