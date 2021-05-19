$(MULTITAIL):
	sudo apt install multitail -y

multitail: | $(MULTITAIL)

optional:: | multitail
