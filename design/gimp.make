$(GIMP):
	sudo apt install gimp -y

gimp: | $(GIMP)

optional:: | gimp
