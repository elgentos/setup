GIMP := $(shell command -v gimp || echo /usr/bin/gimp)

$(GIMP):
	sudo apt install gimp -y

gimp: | $(GIMP)

optional:: | gimp
