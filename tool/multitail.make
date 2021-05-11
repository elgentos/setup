MULTITAIL := $(shell command -v multitail || echo /usr/bin/multitail)

$(MULTITAIL):
	sudo apt install multitail -y

multitail: | $(MULTITAIL)

optional:: | multitail
